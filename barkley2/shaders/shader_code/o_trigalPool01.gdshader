shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_enable, filter_nearest;

group_uniforms reflection;
uniform float offSet = 0;
uniform float YDistortion: hint_range(0.05, 2.0, 0.05) = 1.0;

group_uniforms water;
uniform sampler2D waterNoise : repeat_enable;
uniform sampler2D waterDistortionNoise : repeat_enable, filter_nearest;
uniform vec4 waterColor : source_color = vec4(0.117, 0.27, 0.58, 1);
uniform float colorCorection : hint_range(0.0, 1.0, 0.01) = 0.35;

group_uniforms water_waves;
uniform float distortionForce : hint_range(0.00, .1, 0.001) = .01;
uniform float WDBrightness : hint_range(0, 3, 0.05) = 1.5;
uniform float WDFreq : hint_range(0.2, .9, 0.05) = 0.6;
uniform float WDSize : hint_range(0.6, 1.2, 0.05) = .9;
uniform float WDSpeed : hint_range(1, 20, 0.05) = 4;
uniform vec2 tiling = vec2(1);
uniform vec2 offSetSpeed = vec2(.1);

group_uniforms BG_distortion;
uniform float backGroundDirX : hint_range(-0.1, 0.1) = 0.01;
uniform float backGroundDirY : hint_range(-0.1, 0.1) = 0.01;


varying float screen_baseY;
varying float screen_bottomY;

void vertex() {
	mat4 t = mat4(vec4(2.0, 0, 0, 0), vec4(0, 2.0, 0, 0), vec4(0, 0, 1.0, 0), vec4(-1.0, -1.0, 0, 1.0));
	mat4 t2 = mat4(vec4(1.0/TEXTURE_PIXEL_SIZE.x/2.0, 0, 0, 0), vec4(0, 1.0/TEXTURE_PIXEL_SIZE.y/2.0, 0, 0), vec4(0), vec4(0,0,0, 1.0));

	vec4 zero_world = (MODEL_MATRIX*t2*(t))*vec4(0, 0.0, 0, 1.0);
	vec4 zero_screen = SCREEN_MATRIX*CANVAS_MATRIX *  zero_world;
	vec2 zero_screen_uv = (inverse(t) * zero_screen).xy;
	screen_baseY = zero_screen_uv.y;


	vec4 bottom_screen = SCREEN_MATRIX * CANVAS_MATRIX * MODEL_MATRIX * vec4(0, 1, 0, 1);
	screen_bottomY = bottom_screen.y;
}

void fragment() {
	vec2 uv = SCREEN_UV;

	uv.y -= screen_baseY;
	uv.y /= (screen_bottomY - screen_baseY);
	uv.y = uv.y * 2.0 - 1.0;
	uv.y *= YDistortion;
	uv.y = uv.y / 2.0 + 0.5;
	uv.y -= 0.5 - YDistortion / 2.0;
	uv.y *= (screen_bottomY - screen_baseY);
	uv.y += screen_baseY;


	vec4 color = vec4(waterColor.rgb , 1);


	vec2 reflected_uv = vec2(uv.x, (screen_baseY * 2.0 - (uv.y - offSet)));
	vec2 noiseUV = UV * tiling + offSetSpeed * TIME;
	float noiseValue = texture(waterDistortionNoise, noiseUV).r;
	reflected_uv = reflected_uv + noiseValue * distortionForce;

	vec2 waterUV = UV * tiling;
	waterUV.x += offSetSpeed.x * TIME;
	waterUV.y += cos(TIME * min(1., offSetSpeed.y)) * 0.01;
	waterUV = waterUV + noiseValue * distortionForce * WDSpeed;


	vec4 noiseColor = texture(waterNoise, waterUV);
	float intensity = smoothstep(WDFreq, WDSize, noiseColor.r);
	color.rgb += intensity * vec3(WDBrightness);
	
	vec2 backGroundUV = SCREEN_UV;
	backGroundUV.x += noiseValue * backGroundDirX;
	backGroundUV.y += noiseValue * backGroundDirY;


	color = mix(texture(SCREEN_TEXTURE, backGroundUV),color, 0.2);
	if (reflected_uv.y > 0.0) {
		color = mix(texture(SCREEN_TEXTURE, reflected_uv), color,0.5);
	}
	COLOR = mix(color, waterColor, colorCorection);

}
