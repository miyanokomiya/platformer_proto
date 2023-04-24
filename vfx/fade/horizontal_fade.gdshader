shader_type canvas_item;

//uniform float fade_from: hint_range(0.0, 1.0) = 0.0;
uniform float fade_to: hint_range(0.0, 1.0) = 0.0;
uniform bool flip = false;
uniform int hframes = 1;

void fragment() {
	float uvx = UV.x;
	float cell_w = 1.0 / float(hframes);
	while (uvx > cell_w) {
		uvx -= cell_w;
	}
	uvx *= float(hframes);
	
	vec4 texture_color = texture(TEXTURE, UV);
	
	float interval = 0.1;
	float adjusted_fade_to = fade_to * 1.1;
	float fade_from = max(0, adjusted_fade_to - interval);
	float alpha = 0.0;
	if (uvx < fade_from) {
		alpha = 0.0;
	} else if (uvx < adjusted_fade_to) {
		float d = max((adjusted_fade_to - uvx) / (adjusted_fade_to - fade_from), 0.0);
		alpha = 1.0 - d;
	} else {
		alpha = 1.0;
	}
	
	if (flip) {
		alpha = 1.0 - alpha;
	}
	
	COLOR = vec4(texture_color.rgb, texture_color.a * alpha);
}
