// Based on https://godotshaders.com/shader/screen-smoke-fog/
shader_type canvas_item;
render_mode blend_mix;

// Stuff related to camera position and offsets
uniform vec2 camera_position;
uniform vec2 camera_offset;
uniform float camera_position_speed: 	hint_range(0.0, 1.0) 	= 0.025;
uniform float camera_offset_speed: 		hint_range(0.0, 1.0) 	= 0.025;

// Uniforms for customization
uniform sampler2D noise_texture_1 : 	repeat_enable;
uniform sampler2D noise_texture_2 : 	repeat_enable;
uniform float noise_blend :				hint_range(0.0, 1.0) 	= 1.0;
uniform float noise_speed_1 :			hint_range(0.0, 1.0) 	= 1.0;
uniform float noise_speed_2 :			hint_range(0.0, 1.0) 	= 1.0;
uniform vec2 noise_dir_1 										= vec2(1.0,+1.0);
uniform vec2 noise_dir_2										= vec2(1.0,-1.0);
uniform vec3 smoke_color : 				source_color 			= vec3(0.8);
uniform float density : 				hint_range(0.0, 1.0) 	= 1.0;

void fragment() {
	vec2 offset = ( (camera_position * camera_position_speed) + (camera_offset * camera_offset_speed) );
	
	vec2 time_offset_1 = TIME * noise_dir_1 * noise_speed_1 * 0.1;
	vec2 time_offset_2 = TIME * noise_dir_2 * noise_speed_2 * 0.1;
	
	// Create distorted UV and sample final noise
	vec2 distorted_uv_1 = UV + time_offset_1 + vec2(offset.x,offset.y * 1.75) * 0.1;
	vec2 distorted_uv_2 = UV + time_offset_2 + vec2(offset.x,offset.y * 1.75) * 0.1;
    
	vec4 final_noise_1 = texture(noise_texture_1, distorted_uv_1);
	vec4 final_noise_2 = texture(noise_texture_2, distorted_uv_2);
    float mixed_noise = mix(final_noise_1, final_noise_2, noise_blend).r;
	
	float smoke_alpha = mixed_noise * density;
    
	// Output color
	COLOR = vec4(smoke_color, smoke_alpha);
}