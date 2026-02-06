shader_type canvas_item;

uniform vec4 top_left_color : 		source_color = vec4(1.0);
uniform vec4 top_right_color : 		source_color = vec4(1.0);
uniform vec4 bottom_left_color : 	source_color = vec4(1.0);
uniform vec4 bottom_right_color : 	source_color = vec4(1.0);
uniform float horizontal_bias : 	hint_range(-1.0, 1.0, 0.01);
uniform float vertical_bias : 		hint_range(-1.0, 1.0, 0.01);

void fragment() {
	COLOR = mix( mix(top_left_color, top_right_color, UV.x + horizontal_bias), mix(bottom_left_color, bottom_right_color, UV.x + horizontal_bias), UV.y + vertical_bias) * COLOR.a; 
}