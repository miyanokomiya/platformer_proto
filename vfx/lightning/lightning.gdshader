/* https://www.reddit.com/r/IndieDev/comments/jxnv5p/i_just_love_experimenting_with_pixel_shaders/ */
shader_type canvas_item;
render_mode unshaded, blend_add;

uniform float timeOffset = 0;
uniform sampler2D noiseMap: repeat_enable; 
uniform vec3 noiseSpeed = vec3(0.41,0.79,0.59);
uniform float speed = 1.0;
uniform float realtime = 0.0;
uniform float valueOffset = 0.4;
uniform float valueScale = 4.0;
uniform vec2 scale = vec2(1,2048);

uniform float minVal = 0;
uniform float maxVal = 0.012;

uniform vec4 bright: source_color;
uniform vec4 dark: source_color;
uniform float focus = 1.0;
uniform float fade = 1.2;

void fragment() {
	float t = speed * (timeOffset + TIME*realtime);
	vec2 luv = UV/scale;
	float n1 = texture(noiseMap,luv+vec2(1,0)*t*noiseSpeed.x).r-0.5;
	float n2 = texture(noiseMap,luv+vec2(-1,0)*t*noiseSpeed.y).g-0.5;
	float n3 = texture(noiseMap,luv+vec2(0,-1)*t*noiseSpeed.z).b;
	
	float f = mix(1.0,clamp(luv.y,0,1),focus);
	float nt = n1*n2*(valueScale*f) + valueOffset;
	float n = clamp(smoothstep(minVal,maxVal,abs(UV.x-nt)+(f*fade-n3)*maxVal),0,1);
	
	
	COLOR=mix(bright,dark,n);
}