shader_type canvas_item;
uniform vec4 color : source_color;
uniform float health;

void fragment() {
// ColorUniform:2
	vec3 n_out2p0 = color.rgb;
	float n_out2p1 = color.a;

// VectorOp:8
	vec3 n_in8p1 = vec3(0.50000, 0.50000, 0.50000);
	vec3 n_out8p0 = n_out2p0 * n_in8p1;

// Input:3
	vec3 n_out3p0 = vec3(UV, 0.0);

// VectorDecompose:4
	float n_out4p0 = n_out3p0.x;
	float n_out4p1 = n_out3p0.y;
	float n_out4p2 = n_out3p0.z;

// ScalarUniform:6
	float n_out6p0 = health;

// Compare:5
	bool n_out5p0 = n_out4p0>=n_out6p0;

// VectorMix:7
	vec3 n_out7p0 = mix(n_out2p0, n_out8p0, vec3(n_out5p0 ? 1.0 : 0.0));

// Output:0
	COLOR.rgb = n_out7p0;

}