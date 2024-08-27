shader_type canvas_item;

uniform float time_scale: hint_range(0.0, 2.0) = 0.25;
uniform float tile_count: hint_range(0.0, 10.0, 1.0) = 3;
uniform vec4 bg_color: source_color = vec4(0.4, 0.4, 0.4, 1.0);


void fragment() {
	vec2 uv = UV;
	float p = 1.0;
	p = min(max(p * 3.0 - 1.8, 0.1), 2.0);
	vec2 r = mod(uv * float(tile_count), 1.0);
	r = vec2(pow(r.x - 0.5, 2.0), pow(r.y - 0.5, 2.0));
	p *= 1.0 - pow(min(1.0, 12.0 * dot(r, r)), 2.0);
	COLOR = bg_color * p;
}
