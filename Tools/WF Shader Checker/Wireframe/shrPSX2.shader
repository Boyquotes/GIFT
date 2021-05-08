shader_type spatial; 
render_mode skip_vertex_transform, diffuse_lambert_wrap, specular_phong, ambient_light_disabled;

uniform vec4 color : hint_color;
uniform sampler2D albedoTex : hint_albedo;
uniform float specular_intensity : hint_range(0, 1);
uniform float resolution = 256;
uniform float cull_distance = 5;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(.0, .0);
uniform bool emissive = true;
uniform bool moving_uv = false;
uniform vec2 uv_speed;

varying vec4 vertex_coordinates;

void vertex() {
	UV = UV * uv_scale + uv_offset + ((moving_uv)?uv_speed*TIME:vec2(0.0));
	
	UV = UV * uv_scale + uv_offset;
	
	float vertex_distance = length((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)));
	
	VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	NORMAL = abs(vec4(NORMAL, 1.) * MODELVIEW_MATRIX).xyz;
	float vPos_w = (PROJECTION_MATRIX * vec4(VERTEX, 1.0)).w;
	VERTEX.xy = vPos_w * floor(resolution * VERTEX.xy / vPos_w) / resolution;
	vertex_coordinates = vec4(UV * VERTEX.z, VERTEX.z, .0);
	
	if (vertex_distance > cull_distance)
		VERTEX = vec3(.0);
}

void fragment() {
	vec4 tex = texture(albedoTex, vertex_coordinates.xy / vertex_coordinates.z);
	
	if (emissive){
		EMISSION = tex.rgb * color.rgb * COLOR.rgb;
		ALBEDO = vec3(0.0);
	} else {
		ALBEDO = tex.rgb * color.rgb * COLOR.rgb;
	}
	
	SPECULAR = specular_intensity;
	ROUGHNESS = 1.0;
}