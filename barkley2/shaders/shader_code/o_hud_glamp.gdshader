// https://godotshaders.com/shader/fill-progress/
shader_type canvas_item;
render_mode blend_mul;

// 0.0 → 1.0
uniform float progress : hint_range(0.0, 1.0) = 0.5;
// Tint applied to the filled (consumed) region
uniform vec4 overlay_color : source_color = vec4(0.0, 0.0, 1.0, 0.75);
// Fill direction: (1,0)=L→R, (-1,0)=R→L, (0,1)=T→B, (0,-1)=B→T, (1,1)=diag, etc.
uniform vec2 fill_dir = vec2(0.0, -1.0);
// Alpha threshold to treat as transparent (mask out)
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.01;
// BORDER SIZE - define a slight border between the not filled and the filled part
uniform float border_size : hint_range(0.0, 0.2) = 0.1;
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    if (tex.a <= alpha_cutoff) {
        discard; // ignore transparent pixels
    }

    // Safe, normalized direction (fallback to +X if near zero)
    vec2 dir = fill_dir;
    float len_dir = length(dir);
    dir = (len_dir < 1e-5) ? vec2(1.0, 0.0) : dir / len_dir;

    // Compute min/max projection of the UV quad [0,1]^2 along 'dir'
    vec2 min_corner = vec2(dir.x > 0.0 ? 0.0 : 1.0, dir.y > 0.0 ? 0.0 : 1.0);
    vec2 max_corner = vec2(1.0 - min_corner.x, 1.0 - min_corner.y);

    float min_proj = dot(min_corner, dir);
    float max_proj = dot(max_corner, dir);

    // Current pixel's normalized coordinate along the fill axis → [0,1]
    float p = dot(UV, dir);
    float t = clamp((p - min_proj) / max(1e-6, (max_proj - min_proj)), 0.0, 1.0);

    // Fill if within progress
    if (t <= progress) {
		COLOR = mix(tex, border_color, border_color.a);
	} else if (t <= progress + border_size){
		COLOR = mix(tex, overlay_color, overlay_color.a);
    } else {
        COLOR = tex;
    }
}
