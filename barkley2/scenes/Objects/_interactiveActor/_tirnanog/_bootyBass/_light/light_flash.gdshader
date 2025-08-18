shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

render_mode blend_add, unshaded;

uniform sampler2D light_texture;
uniform vec3 light_color = vec3(255, 255, 255);  // Default to white
uniform float brightness : hint_range(0.0, 1.0) = 0.5;
uniform float attenuation_strength : hint_range(0.0, 1.0) = 0.5;
uniform float intensity : hint_range(0.0, 10.0) = 1.0;
uniform float max_brightness : hint_range(0.0, 10.0) = 1.0;  // Maximum allowable brightness

void fragment() {
    // Sample the light texture at the current UV coordinates
    vec4 light_tex_color = texture(light_texture, UV);
    // Sample the underlying texture color
    vec4 under_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    // Normalize the light color from 0-255 to 0.0-1.0
    vec3 normalized_light_color = light_color / 255.0;
    // Calculate the brightness of the underlying pixel (using the luminance formula)
    float under_brightness = dot(under_color.rgb, vec3(0.299, 0.587, 0.114));
    // Adjust the final color by modulating the light texture with brightness,
    // light color, and the brightness of the underlying pixel
    float attenuation = mix(1.0, under_brightness, attenuation_strength);
    vec4 final_color = light_tex_color * attenuation * vec4(normalized_light_color, 1.0) * brightness * intensity;
    // Clamp the resulting color to ensure it does not exceed the max_brightness
    float max_rgb = max_brightness;
    vec3 clamped_color = min(final_color.rgb, vec3(max_rgb));

    // Use additive blending with the background
    COLOR = vec4(clamped_color, light_tex_color.a);
}