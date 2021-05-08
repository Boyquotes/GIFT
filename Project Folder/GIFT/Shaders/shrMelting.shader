shader_type canvas_item;

uniform float amount :hint_range(0,10) = 0;

void fragment(){
	vec2 uv = FRAGCOORD.xy / (1.0 /SCREEN_PIXEL_SIZE).xy;
	uv.y += .01 * amount * fract(sin(dot(vec2(uv.x), vec2(12.9, 78.2)))* 437.5);
	
	COLOR = texture(SCREEN_TEXTURE, uv);
}