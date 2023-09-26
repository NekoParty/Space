shader_type spatial;

uniform sampler2D albedo_day;
uniform sampler2D albedo_night;

uniform float emission_strength = 1.0;

uniform sampler2D normal_map;
uniform sampler2D spec_map;

uniform sampler2D cloud_map;

uniform float rotation_speed = 0.0;


void fragment() {
	float uv_offset = rotation_speed * TIME;
	ALBEDO = texture(albedo_day,UV+ vec2(uv_offset,0.0)).rgb;
	ALBEDO += vec3(1.0) * texture(cloud_map,UV+ vec2(uv_offset*2.5,0.0)).r;
	float emi_strength = texture(albedo_night,UV+ vec2(uv_offset,0.0)).r;
	if (emi_strength > 0.1){
		EMISSION = texture(albedo_night,UV+ vec2(uv_offset,0.0)).rgb * emission_strength;
	}
	NORMAL_MAP = texture(normal_map,UV + vec2(uv_offset,0.0)).rgb;
	SPECULAR = texture(spec_map,UV+ vec2(uv_offset,0.0)).r;
	ROUGHNESS = 1.0 - texture(spec_map,UV+ vec2(uv_offset,0.0)).r;
}
