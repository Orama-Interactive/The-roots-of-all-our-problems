shader_type canvas_item;

uniform sampler2D old_tex;
uniform sampler2D new_tex;

void fragment() {
	COLOR = texture(old_tex, UV) * step(UV.x, 0.5) + texture(new_tex, UV) * step(1.0 - UV.x, 0.5);
}
