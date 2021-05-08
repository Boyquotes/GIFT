shader_type spatial; 
render_mode skip_vertex_transform, diffuse_lambert_wrap, specular_phong, ambient_light_disabled;

uniform vec4 color : hint_color;
uniform sampler2D albedoTex : hint_albedo;
uniform float specular_intensity : hint_range(0, 1);
uniform float resolution = 100;
uniform float cull_distance = 100;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(.0, .0);
uniform bool stippled_transparent = false;
uniform bool moving_uv = false;
uniform vec2 uv_speed = vec2(0,-1);

void vertex() {
	UV = UV * uv_scale + uv_offset + ((moving_uv)?uv_speed*TIME:vec2(0.0));
	
	float vertex_distance = length((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)));
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	NORMAL = abs(vec4(NORMAL, 1.) * MODELVIEW_MATRIX).xyz;
	float vPos_w = (PROJECTION_MATRIX * vec4(VERTEX, 1.0)).w;
	VERTEX.xy = vPos_w * floor(resolution * VERTEX.xy / vPos_w) / resolution;
	
	if (vertex_distance > cull_distance)
		VERTEX = vec3(.0);
}

void fragment() {
	if (stippled_transparent && (mod(SCREEN_UV.x*VIEWPORT_SIZE.x+floor(mod(SCREEN_UV.y*VIEWPORT_SIZE.y, 2.0)), 2.0)<1.0)){
		discard;
	}
	
	vec4 tex = texture(albedoTex, UV);
	
	EMISSION = tex.rgb * COLOR.rgb;
	ALBEDO = vec3(0.0);
	
	SPECULAR = specular_intensity;
}
