shader_type canvas_item;

uniform float mix_weight: hint_range(0.0, 1.0) = 1.0;
uniform float alpha: hint_range(0.0, 1.0) = 1.0;
uniform vec4 color: source_color = vec4(1, 1, 1, 1);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 white = vec3(1, 1, 1);
	vec3 whitened_texture_rgb = mix(texture_color.rgb, color.rgb, mix_weight);
	COLOR = vec4(whitened_texture_rgb, texture_color.a * color.a * alpha);
}
