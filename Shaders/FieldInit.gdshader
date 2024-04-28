shader_type spatial;

uniform sampler2D noise;
uniform vec3 initial_color: source_color;
uniform vec3 blend_color: source_color;

void vertex() {
	VERTEX.y += sin(VERTEX.x/10.0)*1.2 + sin(VERTEX.x/16.0)*3.0;
	VERTEX.y += sin(VERTEX.z/32.0)*2.5 + sin(VERTEX.z/16.0)*3.0 + 6.5;
	VERTEX.y -= normalize(texture(noise,UV)).r*5.0-5.0;
}

void fragment()
{
	ALBEDO = mix(initial_color,blend_color,texture(noise,UV).rgb*0.5);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
