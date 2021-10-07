//SHADER ORIGINALY CREADED BY "demofox" FROM SHADERTOY
//PORTED AND MODIFYED TO GODOT BY AHOPNESS (@ahopness)
//LICENSE : CC0
//COMATIBLE WITH : GLES2, GLES3, WEBGL
//SHADERTOY LINK : https://www.shadertoy.com/view/XdXSzX

shader_type canvas_item;

uniform float contrast :hint_range(0.0, 3.0) = 1.0;
uniform float brightness :hint_range(-1.0, 1.0) = 0.0;

const float PI = 3.141592653589793238462;
uniform float strenth :hint_range(-0.2, 0.2) = 0.1;

void fragment(){
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
	
	// Waves
	float scale = PI;
	uv += vec2(sin(TIME + uv.y * scale),cos(TIME + uv.x * scale)) * strenth;
	
	
	vec3 pixelColor = texture(SCREEN_TEXTURE, uv).xyz;
	
	// Grayscale
	float pixelGrey = dot(pixelColor, vec3(0.2126, 0.7152, 0.0722));
	pixelColor = vec3(pixelGrey);
	
	// Contrast & Bightness
	pixelColor.rgb = ((pixelColor.rgb - 0.5) * max(contrast, 0.0)) + 0.5;
	pixelColor.rgb += brightness;
	
	COLOR = vec4(pixelColor, 1.0);
}