shader_type canvas_item;
uniform sampler2D ST : hint_screen_texture, filter_linear_mipmap_anisotropic;
uniform vec4 scanline_color : source_color = vec4(0, 0, 0, 1);
uniform vec4 flicker_color : source_color = vec4(0, 0, 0, 1);
uniform float scanlines_count = 10.0;
uniform float scanlines_intensity = 0.05;
uniform float flicker_speed = 30.0;
uniform float flicker_intensity : hint_range(0.0, 1.0, 0.001) = 0.025;
uniform float color_offset = 1.5;
uniform float blur = 0.15;

void fragment() {
	vec2 pixel_size = 1.0 / vec2(textureSize(ST, 0));
	float offset = color_offset * pixel_size.x;

	// chromatic aberration
	float channel_r = textureLod(ST, SCREEN_UV + vec2(offset, 0.0), blur).r;
	float channel_g = textureLod(ST, SCREEN_UV, blur).g;
	float channel_b = textureLod(ST, SCREEN_UV + vec2(-offset, 0.0), blur).b;
	vec4 aberrate = vec4(channel_r, channel_g, channel_b, 1.0);

	// scanline flicker
	float mix_value = sin((UV.y - (TIME * flicker_speed)) * 10.0) * flicker_intensity;
	vec4 flicker = mix(aberrate, flicker_color, mix_value);

	// scanlines
	float scanlines = sin(FRAGCOORD.y * scanlines_count) * scanlines_intensity;
	vec4 final = mix(flicker, scanline_color, scanlines);

	COLOR = final;
}
