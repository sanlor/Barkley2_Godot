shader_type canvas_item;

uniform float ratio : hint_range(0.0, 1.0, 0.01) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(UV.y > ratio) {
		COLOR = vec4(1.0,1.0,1.0,1.0);
		}
	else {

		}
	}