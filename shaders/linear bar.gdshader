shader_type canvas_item;

uniform vec4 color_0: source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform vec4 color_1: source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform vec4 color_2: source_color = vec4(0.2, 1.0, 0.2, 1.0);

uniform float health_value: hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float limit_0: hint_range(0.0, 1.0, 0.001) = 0.333;
uniform float limit_1: hint_range(0.0, 1.0, 0.001) = 0.666;

void fragment() {
	vec3 color_0_bg = color_0.rgb * vec3(0.50000, 0.50000, 0.50000);
	vec3 color_1_bg = color_1.rgb * vec3(0.50000, 0.50000, 0.50000);
	vec3 color_2_bg = color_2.rgb * vec3(0.50000, 0.50000, 0.50000);
	if (UV.x < limit_1) { COLOR.rgb = mix(color_0.rgb, color_0_bg, vec3(vec3(UV, 0.0).x>=health_value ? 1.0 : 0.0)); }
	if (UV.x >= limit_0 && UV.x < limit_1) { COLOR.rgb = mix(color_1.rgb, color_1_bg, vec3(vec3(UV, 0.0).x>=health_value ? 1.0 : 0.0));  }
	if (UV.x >= limit_1) { COLOR.rgb = mix(color_2.rgb, color_2_bg, vec3(vec3(UV, 0.0).x>=health_value ? 1.0 : 0.0));  }
	
}