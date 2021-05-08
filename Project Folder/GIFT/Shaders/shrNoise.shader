//SHADER ORIGINALY CREADED BY "juniorxsound" FROM SHADERTOY
//PORTED AND MODIFYED TO GODOT BY AHOPNESS (@ahopness)
//
//SHADERTOY LINK : https://www.shadertoy.com/view/ldScWw

shader_type spatial;

uniform float amount :hint_range(0, .1) = .1;

float grain (vec2 st, float time){
	return fract(sin(dot(st.xy, vec2(17.0,180.)))* 2500. + time);
}

void fragment(){
	//Coords
	vec2 uv = UV * vec2(2);
	
	//Produce some noise based on the coords
	//vec3 grainPlate = vec3(grain(uv, TIME));
	vec3 grainPlate = vec3(grain(uv, TIME));
	
	EMISSION = vec3(grainPlate);
	ALBEDO = vec3(grainPlate); 
}