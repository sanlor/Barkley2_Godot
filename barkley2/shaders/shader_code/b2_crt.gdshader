// https://godotshaders.com/shader/retro-tv-shader/
shader_type canvas_item;

// uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;

uniform float scanline_count : hint_range(0, 1800) = 50.0;
uniform float scale : hint_range(0.0, 5.0, 0.1) = 1.0;
uniform float red_offset : hint_range(-5.0, 5.0, 0.1) = 1.0;
uniform float blue_offset : hint_range(-5.0, 5.0, 0.1) = 1.0;
uniform float green_offset : hint_range(-5.0, 5.0, 0.1) = 1.0;
uniform bool bypass_scale = false;

vec2 uv_curve(vec2 uv)
{
	if (bypass_scale)
	{
		return uv;
	}
	else
	{
		uv = (uv - 0.5) * 2.0;
	
		//You can modify the numbers and try different values
		uv.x *= 1.0 + pow(abs(uv.y) / 3.0, 2.0);
		uv.y *= 1.0 + pow(abs(uv.x) / 3.0, 2.0);
		
		//The scale part (you can delete it when you want)
		uv /= scale;
		
		uv = (uv/2.0) + 0.5;
		return uv;
	}
	
}


void fragment()
{	
	
	//You can modify the *3.0, *-3.0 for a bigger or smaller 
	float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * red_offset ), 0.0).r;
	float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * green_offset ), 0.0).g;
	float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * blue_offset ), 0.0).b;
	
	
	//If you dont want scanlines you can just delete this part
	float s = sin(uv_curve(SCREEN_UV).y * scanline_count * PI * 2.0);
	s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
	
	
	COLOR = vec4(r, g, b, 1.0) * scan_line;
}