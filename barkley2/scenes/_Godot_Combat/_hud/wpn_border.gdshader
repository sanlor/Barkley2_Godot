shader_type canvas_item;

uniform vec4 line_color = vec4(1);
uniform float line_thickness = 1.0;
uniform float frequency = 10.0;
uniform float phase_speed = 1.0;

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	
	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y * 0.5)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y * 0.5)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y * 0.5)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y * 0.5)).a;
	outline = round(min(outline, 1.0));
	float mul = round(texture(TEXTURE, UV).a);
	if (mul > 0.5) {
		COLOR = texture(TEXTURE, UV);
	}else if (outline > 0.5) {
		vec2 pos = UV - vec2(0.5);
		float angle = atan(pos.y, pos.x);
		if (angle < 0.0) {
		angle += 2.0 * PI;
		}
		float ring = step(0.0, sin(frequency * angle + TIME * phase_speed));
		COLOR = vec4(line_color.rgb, ring * line_color.a);
	}
}