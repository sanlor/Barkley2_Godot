shader_type canvas_item;

uniform vec3 color: source_color = vec3(0.5);
uniform float speed: hint_range(0.01, 10.0, 0.01) = 0.1;
uniform float density: hint_range(1.0, 1000.0, 1.0) = 100.0;
uniform float compression: hint_range(0.1, 1.0, 0.01) = 0.2;
uniform float trail_size: hint_range(5.0, 100.0, 0.1) = 50.0;
uniform float brightness: hint_range(0.1, 10.0, 0.1) = 5.0;

void fragment() {
	vec2 uv = -UV;
	float time = TIME * speed;
	uv.x *= density;
	vec2 duv = vec2(floor(uv.x), uv.y) * compression;
	float offset = sin(duv.x);
	float fall = cos(duv.x * 30.0);
	float trail = mix(100.0, trail_size, fall);
	float drop = fract(duv.y + time * fall + offset) * trail;
	drop = 1.0 / drop;
	drop = smoothstep(0.0, 1.0, drop * drop);
	drop = sin(drop * PI) * fall * brightness;
	float shape = sin(fract(uv.x) * PI);
	drop *= shape * shape;
	COLOR = vec4(color * drop, color.r);
}

