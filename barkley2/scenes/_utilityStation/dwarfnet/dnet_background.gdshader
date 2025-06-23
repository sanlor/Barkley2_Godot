// https://godotshaders.com/shader/panning/
shader_type canvas_item;

// --- Uniforms --- //
uniform float speed 	= float(1.0);
uniform vec2 dir 		= vec2(0.0, 0.0);

// --- Functions --- //
void fragment() {
	//COLOR = texture(TEXTURE, mod(UV + TIME * dir * speed, 1.0));
	COLOR = texture(TEXTURE, mod(UV + TIME * dir, 1.0));
}