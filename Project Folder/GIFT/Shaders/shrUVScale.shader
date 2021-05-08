shader_type canvas_item;

uniform vec2 scale = vec2(1.0, 1.0);
uniform bool centered;

void fragment(){
	vec2 resolution = (1.0 /SCREEN_PIXEL_SIZE);
	vec2 uv;
	
	if (centered){
	uv = (FRAGCOORD.xy  - 0.5 * resolution.xy) / min(resolution.x, resolution.y);
	}else{
	uv = FRAGCOORD.xy / resolution.xy;
	}
	uv *= scale;
	
	uv = fract(uv);
	
	COLOR = texture(SCREEN_TEXTURE, uv);
}