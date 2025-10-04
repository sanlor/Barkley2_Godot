shader_type canvas_item;

uniform float ratio : hint_range(0.0,1.0);

void fragment() {
    vec2 uv = UV;
    if (uv.y > ratio) {
        COLOR = texture(TEXTURE, uv);
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 0.0);
    }
}