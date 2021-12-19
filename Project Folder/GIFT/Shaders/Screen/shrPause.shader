//SHADER ORIGINALY CREADED BY "demofox" FROM SHADERTOY
//PORTED AND MODIFYED TO GODOT BY AHOPNESS (@ahopness)
//LICENSE : CC0
//COMATIBLE WITH : GLES2, GLES3, WEBGL
//SHADERTOY LINK : https://www.shadertoy.com/view/XdXSzX

shader_type canvas_item;

uniform float contrast :hint_range(0.0, 3.0) = 1.0;
uniform float brightness :hint_range(-1.0, 1.0) = 0.0;

uniform float seed = 81.0;
uniform float power : hint_range( 0.0, 1.0 ) = 0.03;
uniform float speed = 0.0;

vec2 random( vec2 pos ){ 
	return fract(sin(vec2(dot(pos, vec2(12.9898,78.233)), dot(pos, vec2(-148.998,-65.233)))) * 43758.5453);
}

void fragment(){
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy + ( random( UV + vec2( seed - TIME * speed, TIME * speed ) ) - vec2( 0.5, 0.5 ) ) * power;
	
	vec3 pixelColor = texture(SCREEN_TEXTURE, uv).xyz;
	
	// Grayscale
	float pixelGrey = dot(pixelColor, vec3(0.2126, 0.7152, 0.0722));
	pixelColor = vec3(pixelGrey);
	
	// Contrast & Bightness
	pixelColor.rgb = ((pixelColor.rgb - 0.5) * max(contrast, 0.0)) + 0.5;
	pixelColor.rgb += brightness;
	
	COLOR = vec4(pixelColor, 1.0);
}