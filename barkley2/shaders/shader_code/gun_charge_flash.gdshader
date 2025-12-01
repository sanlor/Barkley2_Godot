// https://godotshaders.com/shader/simple-2d-random-shake-%ef%bc%86-flash/
shader_type canvas_item;

uniform float hit_effect : hint_range(0,1) = 0.0;
uniform float flash_speed = 30.0;
uniform vec4 flash_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void vertex() {
    if (hit_effect > 0.0) {
        float time = TIME * 30.0;
        vec2 random_offset = vec2(
            rand(vec2(time, 0.0)) * 2.0 - 1.0,
            rand(vec2(time, 10.0)) * 2.0 - 1.0
        );
        //VERTEX += random_offset * shake_intensity * hit_effect;
    }
}

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    if (hit_effect > 0.0) {
        float flash = sin(TIME * flash_speed) * 0.5 + 0.5;
        flash *= original_color.a; 
        
        vec4 final_color = mix(original_color, flash_color, flash);
        final_color = mix(original_color, final_color, hit_effect);
        final_color.a = original_color.a; 
        
        COLOR = final_color;
    } else {
        COLOR = original_color;
    }
}