// https://godotshaders.com/shader/line-jitter-stroke-shake-effect/
shader_type canvas_item;

uniform vec4 color_overide = vec4(1.0,1.0,1.0,1.0);
uniform bool shaking       = false;
uniform float amplitude    = 1.0;
uniform float noise_scale  = 20.0;
uniform float noise_speed  = 20.0;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = hash(i + vec2(0.0,0.0));
  float b = hash(i + vec2(1.0,0.0));
  float c = hash(i + vec2(0.0,1.0));
  float d = hash(i + vec2(1.0,1.0));
  vec2 u = f*f*(3.0-2.0*f);
  return mix(a, b, u.x) +
  (c - a) * u.y * (1.0 - u.x) +
  (d - b) * u.x * u.y;
}

void fragment() {
  if (shaking) {
    vec2 uv = UV;
    vec4 orig = texture(TEXTURE, uv);
    if (orig.a <= 0.0) {
      discard;
    }

    // Generate two noise values to construct a random direction.
    float nx = noise(uv * noise_scale + vec2(TIME * noise_speed, 0.0));
    float ny = noise(uv * noise_scale + vec2(0.0, TIME * noise_speed));
    // Map [0,1] to [-1,1]
    vec2 rand_dir = normalize(vec2(nx * 2.0 - 1.0, ny * 2.0 - 1.0));

    // Use another noise value to determine the jitter amplitude sign.
    float n = noise(uv * noise_scale + vec2(TIME * noise_speed));
    float off = (n * 2.0 - 1.0) * amplitude;

    // Offset along a random direction
    vec2 uv2 = uv + rand_dir * off * TEXTURE_PIXEL_SIZE;
    COLOR = texture(TEXTURE, uv2);
	COLOR *= color_overide;
  }
}