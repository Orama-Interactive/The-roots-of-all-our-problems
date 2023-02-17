shader_type canvas_item;

// This shader converts RGB to LCh by doing RGB -> XYZ -> Lab -> LCh
// and vice versa, by doing LCh -> Lab -> XYZ -> RGB
// Thanks to http://www.brucelindbloom.com/index.html?Math.html
// and https://www.easyrgb.com/en/math.php

const vec3 xyz_white = vec3(95.0456, 100.0, 108.8754);
const mat3 xyz2rgb_matrix = mat3(
	vec3(3.240479, -1.537150, -0.498535),
	vec3(-0.969256, 1.875992, 0.041556),
	vec3(0.055648, -0.204043, 1.057311)
);
const mat3 rgb2xyz_matrix = mat3(
	vec3(0.412453, 0.357580, 0.180423),
	vec3(0.212671, 0.715160, 0.072169),
	vec3(0.019334, 0.119193, 0.950227)
);
const float xyz_e = 0.008856;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

vec3 xyz2rgb(in vec3 XYZ) {
	XYZ = XYZ * xyz2rgb_matrix / 100.0;
	bvec3 tmp = greaterThan(XYZ, vec3(0.0031308));
	XYZ = (vec3(tmp) * (1.055 * pow(XYZ, vec3(1.0 / 2.4)) - 0.055))
		+ (vec3(not(tmp)) * (XYZ * 12.92));
    
	return XYZ;
}

vec3 rgb2xyz(in vec3 RGB) {
	bvec3 tmp = greaterThan(RGB, vec3(0.04045));
	RGB = (vec3(tmp) * pow((RGB + 0.055) / 1.055, vec3(2.4))) 
		+ (vec3(not(tmp)) * (RGB / 12.92));
	RGB *= 100.0;
	return RGB * rgb2xyz_matrix;
}

vec3 lab2xyz(vec3 LAB) {
	vec3 XYZ = vec3(0.0);
	XYZ.y = (LAB.x + 16.0) / 116.0;
	XYZ.x = LAB.y / 500.0 + XYZ.y;
	XYZ.z = XYZ.y - LAB.z / 200.0;
	bvec3 mask = greaterThan(pow(XYZ, vec3(3.0)), vec3(xyz_e));
	XYZ = (vec3(mask) * pow(XYZ, vec3(3.0)))
		+ (vec3(not(mask)) * ((XYZ - 16.0 / 116.0) / 7.787));
	return XYZ * xyz_white;
}

vec3 xyz2lab(vec3 XYZ) {
	vec3 LAB = XYZ;
	LAB /= xyz_white;
	bvec3 mask = greaterThan(LAB, vec3(xyz_e));
	LAB = (vec3(mask) * pow(LAB, vec3(1.0 / 3.0)))
		+ (vec3(not(mask)) * (7.787 * LAB + 16.0 / 116.0));

	return vec3(
		116.0 * LAB.y - 16.0,
		500.0 * (LAB.x - LAB.y),
		200.0 * (LAB.y - LAB.z)
	);
}

vec3 lch2lab(vec3 LCH) {
	vec3 LAB = LCH;
	LAB.y = cos(LAB.z) * LCH.y;
	LAB.z = sin(LAB.z) * LCH.y;
	return LAB;
}

vec3 lab2lch(vec3 LAB) {
	vec3 LCH = LAB;
	LCH.y = sqrt(pow(LCH.y, 2.0) + pow(LCH.z, 2.0));
	LCH.z = atan(LCH.z, LCH.y);
	LCH.z = mod(LCH.z, TAU);
	return LCH;
}

vec3 lab2rgb(vec3 LAB) {
	return xyz2rgb(lab2xyz(LAB));
}

vec3 rgb2lab(vec3 RGB) {
	return xyz2lab(rgb2xyz(RGB));
}

vec3 rgb2lch(vec3 RGB) {
	return lab2lch(rgb2lab(RGB));
}

vec3 lch2rgb(vec3 LCH) {
	return lab2rgb(lch2lab(LCH));
}

void fragment() {
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec3 lch = rgb2lch(color);
	// Get the lightness of white, inspired by GIMP's LCh Lightness layer blending mode
	vec3 lch_white = rgb2lch(vec3(1.0));
	lch.r = lch_white.r;
	COLOR.rgb = lch2rgb(lch); 
}
