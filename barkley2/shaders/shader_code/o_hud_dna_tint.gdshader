shader_type canvas_item;
render_mode blend_mul, unshaded;

// AAAAAAAAAAAAAAHH I hate shaders!!!!!!!!!!!!!!!
// Fuck this.

uniform vec4 bio_color 		: source_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 zauber_color 	: source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform vec4 cosmic_color 	: source_color = vec4(1.0, 0.0, 1.0, 1.0);
uniform vec4 cyber_color 	: source_color = vec4(1.0, 0.5, 0.0, 1.0);

void fragment() {
	vec4 my_color 		= bio_color;
	if(VERTEX.x < 0.85) {
		COLOR =  my_color;
		}
	else {
		COLOR = my_color;
		}
}