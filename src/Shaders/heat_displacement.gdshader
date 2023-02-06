shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture;
uniform sampler2D noise;

void fragment() {;
	float time_scale = 0.01;
	vec2 noise_uv = UV;
	noise_uv.x += (TIME * time_scale);
	noise_uv.y += (TIME * time_scale);  
	vec2 noise_value = texture(noise, noise_uv).rg;
	noise_value = noise_value * 2.0 - 1.0; // Clamp to (-1, 1) instead of (0, 1)
	vec2 screen_uv = SCREEN_UV;
	screen_uv += noise_value * 0.008;
//	vec3 screen_color = texture(screen, screen_uv).rgb;

	COLOR = texture(screen, screen_uv);
}
