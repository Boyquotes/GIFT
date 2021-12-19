shader_type canvas_item;

const float Pi = 6.28318530718; // pi*2

uniform float grain_strenth :hint_range(0.0, 2.0) = .8;

uniform float blur_directions :hint_range(0, 64) = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
uniform float blur_quality :hint_range(0, 10) = 3.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
uniform float blur_amount :hint_range(0, 128) = 8.0; // BLUR SIZE (Radius)

uniform float shake_strength : hint_range(0,10) = .5;
uniform float shake_seed :hint_range(1.0, 64.0) = 1.0;

uniform float fx_brightness :hint_range(0, 2) = 1;

vec2 Circle(float Start, float Points, float Point) {
	float Rad = (3.141592 * 3.0 * (1.0 / Points)) * (Point + Start);
	return vec2(sin(Rad), cos(Rad));
}
float noise(vec2 st, float time){
	return fract(sin(dot(st.xy, vec2(17.0,180.)))* 2500. + time);
}

 vec2 a_trunc(vec2 x) {
 	return vec2(x.x < 0.0 ? -floor(-x.x) : floor(x.x), x.y < 0.0 ? -floor(-x.y) : floor(x.y));
 }

void vertex(){
	vec2 VERTEX_OFFSET = VERTEX;
	VERTEX_OFFSET.x += (noise(a_trunc(VERTEX_OFFSET) + TIME + cos(shake_seed), 1) - 0.5) * shake_strength;
	
	VERTEX_OFFSET.y += (noise(a_trunc(VERTEX_OFFSET) + TIME + sin(shake_seed), 1) - 0.5) * shake_strength;
	
	VERTEX = VERTEX_OFFSET;
}

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	vec2 uv = UV;
	
	// BLUR
    vec4 blur = texture(TEXTURE, uv);
	
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 Radius = blur_amount/iResolution.xy;
	
	for( float d = 0.0; d < Pi; d += Pi / blur_directions){
		for(float i = 1.0 / blur_quality; i <= 1.0; i += 1.0 / blur_quality){
			blur += texture(TEXTURE, uv + vec2(cos(d), sin(d)) * Radius * i);
		}
	}
	
	blur /= blur_quality * blur_directions - 15.0;
	
	// GRAIN
	vec4 grainPlate = vec4(noise(uv, TIME) * grain_strenth);
	
	// END
	COLOR = color + ((blur * fx_brightness) * grainPlate);
}