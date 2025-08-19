shader_type canvas_item;

uniform bool single_color  = false;

void fragment() {
	if (single_color) {
		COLOR.rgb = vec3(1.0,1.0,1.0);
	}
	else {
		COLOR = texture(TEXTURE, UV);
	}
	
}
