shader_type canvas_item;

// Look, im learning to shade!
uniform sampler2D texture_1 : source_color, repeat_enable, filter_nearest;
uniform sampler2D texture_2 : source_color, repeat_enable, filter_nearest;
uniform float transform_ratio : hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
	vec4 texture_1_color = texture(texture_1, UV );
	vec4 texture_2_color = texture(texture_2, UV );
	COLOR.rgb = (texture_1_color.rgb * transform_ratio) + (texture_2_color.rgb * abs(transform_ratio - 1.0) );
}
