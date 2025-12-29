// https://godotshaders.com/shader/universal-text-shine-bitmap-font-compatible-360-angle/
// Heavly modified
shader_type canvas_item;

uniform vec4 color_1 : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 color_2 : source_color = vec4(0.5, 0.5, 0.5, 1.0);

// Must be set via GDScript!
uniform vec2 text_size = vec2(100.0, 100.0); 

varying vec2 pixel_pos;

void vertex() {
	pixel_pos = VERTEX;
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 original_color = tex * COLOR;
	// 1. Normalize position based on label size (0.0 to 1.0)
	vec2 box_uv = pixel_pos / text_size;
	
	COLOR = original_color;
	if ( original_color.rgb != vec3(0.0,0.0,0.0) ) {
		COLOR.rgb = mix(COLOR.rgb, color_1.rgb, box_uv.y);
		COLOR.rgb = mix(color_2.rgb, COLOR.rgb, box_uv.y);
		}
}
