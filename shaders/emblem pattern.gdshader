shader_type canvas_item;


uniform vec4 color: source_color = vec4(1.0);
uniform bool is_inverse = true;
uniform bool is_circle = true;
uniform bool is_perfect = true;
uniform float offset: hint_range(0.0, 0.5, 0.25) = 0.00;
//uniform float offset_y: hint_range(0.0, 0.5, 0.5) = 0.00;
uniform float zoom_scale: hint_range(0.5, 2.5, 0.5) = 1.00;
uniform float radius_scale: hint_range(1.0, 8.0, 1.0) = 1.00;

float circle(in vec2 _st, in float _radius) {
	vec2 l = _st-vec2(0.5);
	float result = smoothstep(_radius, _radius, dot(l,l) * 4.0);
	if (is_inverse) { result = 1. - result; }
	return result;
}

float circlePattern(vec2 st, float r) {
    return  circle(st+vec2(0.,-.5), r)+
            circle(st+vec2(0.,.5), r)+
            circle(st+vec2(-.5,0.), r)+
            circle(st+vec2(.5,0.), r);
}

void fragment() {
	vec2 uv = UV * zoom_scale + vec2(offset, offset);
	if (offset == 0.5) {uv.y -= offset;}
	//if (is_mirror) { uv.x += 0.5; }
	uv = fract(uv);
	float radius = 1.;
	
	if (!is_perfect) {
		radius = 1. / radius_scale;
		if (is_circle) { radius = radius_scale / (1. + radius_scale); }
	}
	
	COLOR = color * circlePattern(uv, radius);
}