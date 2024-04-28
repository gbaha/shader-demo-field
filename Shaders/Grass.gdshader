shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise;
uniform vec3 color1: source_color;
uniform vec3 color2: source_color;
uniform vec3 color3: source_color;
uniform vec4 compressor;

varying vec3 worldPosition;

void vertex() {
	worldPosition = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	VERTEX.y += sin(worldPosition.x/10.0)*1.2 + sin(worldPosition.x/16.0)*3.0;
	VERTEX.y += sin(worldPosition.z/32.0)*2.5 + sin(worldPosition.z/16.0)*3.0 + 6.5;
	VERTEX.y -= normalize(texture(noise,UV)).r*5.0-6.0;
	
	if(pow(abs(worldPosition.x-compressor.x),2)+pow(abs(worldPosition.z-compressor.z),2) <= pow(compressor.w,2) && compressor.w != 0.0)
	{
		vec3 compressDirection = normalize(vec3(worldPosition.x-compressor.x,0.0,worldPosition.z-compressor.z));
		compressDirection = (vec4(compressDirection,1.0)*MODEL_MATRIX).xyz;
		VERTEX += vec3(compressDirection.x,-1.5,compressDirection.z) * smoothstep(compressor.w,0.0,distance(compressor.xyz,worldPosition)) * (1.0-UV.y) * 16.0;
	}
	else
	{
		VERTEX.x += (0.8-sin(TIME))*(1.0-UV.y)*normalize(texture(noise,UV)).r*0.8;
		VERTEX.z += (0.8-sin(TIME))*(1.0-UV.y)*0.8;
	}
}

void fragment() {
	
	ALBEDO = mix(color2, color1, UV.y);
	NORMAL = vec3(0.0,1.0,0.0);
	
//	ALBEDO = vec3(normalize(vec3(worldPosition.xyz-compressor.xyz))*(compressor.w-distance(compressor.xyz,worldPosition))*(1.0-UV.y));
//	if(!FRONT_FACING)
//		NORMAL = -NORMAL;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
