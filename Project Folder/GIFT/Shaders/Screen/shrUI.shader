shader_type canvas_item;

uniform vec4 modular :hint_color = vec4(1);
uniform float blur_amount :hint_range(0.0, 1.5) = .02;
uniform float grain_strenth :hint_range(0.0, 2.0) = .8;

vec2 Circle(float Start, float Points, float Point) {
	float Rad = (3.141592 * 3.0 * (1.0 / Points)) * (Point + Start);
	return vec2(sin(Rad), cos(Rad));
}
float grain(vec2 st, float time){
	return fract(sin(dot(st.xy, vec2(17.0,180.)))* 2500. + time);
}

void fragment(){
	// MISC
	vec4 color = texture(TEXTURE, UV) * modular;
	vec2 uv = UV;
	
	// BLUR
	vec2 PixelOffset = blur_amount / UV;
	float Start = 2.0 / 14.0;
	vec2 Scale = 0.66 * 4.0 * 2.0 * PixelOffset.xy;
	
	vec4 N0 = texture(TEXTURE, uv + Circle(Start, 14.0, 0.0) * Scale);
	vec4 N1 = texture(TEXTURE, uv + Circle(Start, 14.0, 1.0) * Scale);
	vec4 N2 = texture(TEXTURE, uv + Circle(Start, 14.0, 2.0) * Scale);
	vec4 N3 = texture(TEXTURE, uv + Circle(Start, 14.0, 3.0) * Scale);
	vec4 N4 = texture(TEXTURE, uv + Circle(Start, 14.0, 4.0) * Scale);
	vec4 N5 = texture(TEXTURE, uv + Circle(Start, 14.0, 5.0) * Scale);
	vec4 N6 = texture(TEXTURE, uv + Circle(Start, 14.0, 6.0) * Scale);
	vec4 N7 = texture(TEXTURE, uv + Circle(Start, 14.0, 7.0) * Scale);
	vec4 N8 = texture(TEXTURE, uv + Circle(Start, 14.0, 8.0) * Scale);
	vec4 N9 = texture(TEXTURE, uv + Circle(Start, 14.0, 9.0) * Scale);
	vec4 N10 = texture(TEXTURE, uv + Circle(Start, 14.0, 10.0) * Scale);
	vec4 N11 = texture(TEXTURE, uv + Circle(Start, 14.0, 11.0) * Scale);
	vec4 N12 = texture(TEXTURE, uv + Circle(Start, 14.0, 12.0) * Scale);
	vec4 N13 = texture(TEXTURE, uv + Circle(Start, 14.0, 13.0) * Scale);
	vec4 N14 = texture(TEXTURE, uv);
	
	float W = 1.0 / 15.0;
	
	vec4 blur = vec4(0);
	
	blur = 
		(N0 * W) +
		(N1 * W) +
		(N2 * W) +
		(N3 * W) +
		(N4 * W) +
		(N5 * W) +
		(N6 * W) +
		(N7 * W) +
		(N8 * W) +
		(N9 * W) +
		(N10 * W) +
		(N11 * W) +
		(N12 * W) +
		(N13 * W) +
		(N14 * W);
	
	// GRAIN
	vec4 grainPlate = vec4(grain(uv, TIME) * grain_strenth);
	
	COLOR = color + ((blur * modular) * grainPlate);
}