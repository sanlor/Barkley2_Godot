shader_type canvas_item;
uniform sampler2D gun_texture : source_color, repeat_enable, filter_nearest; // res://barkley2/assets/b2_original/guns/FrankieGuns.png
uniform vec2 atlas_pos = vec2(0.0);
uniform vec2 chunk_offset = vec2(0.0);
uniform vec2 chunk_size = vec2(1.0);

const vec2 gun_cell 		= vec2(49.0,24.0);
const vec2 gun_text 		= vec2(81.0,26.0); // values used in the atlas

// I give up. im terrible with shaders.

void vertex() {

}

void fragment() {
	vec2 atlas = UV / gun_text;
	COLOR.a = 0.0;

	if (UV.x > chunk_offset.x) {
		if (UV.y > chunk_offset.y) {
			if (UV.x <= chunk_size.x + chunk_offset.x) {
				if (UV.y <= chunk_size.y + chunk_offset.y) {
					COLOR = texture(gun_texture, ( atlas_pos / (gun_cell * gun_text) ) + atlas );
				}
			}
		}
	}

}
