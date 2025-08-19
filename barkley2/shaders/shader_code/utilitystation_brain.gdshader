shader_type canvas_item;

// Wow, so sophisticated! Using shaders and shit...
uniform float progress : hint_range(0, 1) = 0.5;
uniform float frequency : hint_range(0.0, 1.0) = 0.025;
uniform float speed : hint_range(0, 10) = 5.0;

void fragment() {
	if (UV.y < (-progress + 1.0) + sin( frequency * VERTEX.x + TIME * speed ) * 0.025 ) {
		discard;
	}
}