shader_type canvas_item;

uniform vec2 speed = vec2(1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, mod(UV + TIME * speed, 1.0));
}
