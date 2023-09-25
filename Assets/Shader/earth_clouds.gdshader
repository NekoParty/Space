shader_type spatial;


uniform sampler2D cloud_map;



uniform float thickness = 0.5;
uniform float speed = 0.005;

void vertex(){
	VERTEX += NORMAL * thickness;
}

void fragment() {
	float uv_offset = TIME * speed;
	ALBEDO = vec3(1.0);
	ALPHA = pow(texture(cloud_map,UV + vec2(uv_offset,0.0)).r,1);
}
