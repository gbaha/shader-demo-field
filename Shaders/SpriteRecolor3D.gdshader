shader_type spatial;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform vec4 new_colorR: source_color;
uniform float sensitivityR: hint_range(0, 1);
uniform vec4 new_colorG: source_color;
uniform float sensitivityG: hint_range(0, 1);
uniform vec4 new_colorB: source_color;
uniform float sensitivityB: hint_range(0, 1);
uniform vec4 new_colorGB: source_color;
uniform float sensitivityGB: hint_range(0, 1);
uniform vec4 new_colorRG: source_color;
uniform float sensitivityRG: hint_range(0, 1);
uniform vec4 new_colorRB: source_color;
uniform float sensitivityRB: hint_range(0, 1);

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	
//	float mask_rgb = step(0.2,length(ALBEDO.rgb*vec3(1.0-old_color.r,1.0-old_color.g,1.0-old_color.b)));
//	ALBEDO = mask_rgb*ALBEDO.rgb+(1.0-mask_rgb)*step(0.2,length(ALBEDO.rgb*old_color.rgb))*new_color.rgb;
	
	float mask_r = step(sensitivityR,length(normalize(ALBEDO.rgb)*vec3(1.0,0.0,0.0)));		//RED
	float mask_g = step(sensitivityG,length(normalize(ALBEDO.rgb)*vec3(0.0,1.0,0.0)));		//GREEN
	float mask_b = step(sensitivityB,length(normalize(ALBEDO.rgb)*vec3(0.0,0.0,1.0)));		//BLUE
	float mask_gb = step(sensitivityGB,length(ALBEDO.rgb*normalize(vec3(0.0,1.0,1.0))));		//CYAN
	float mask_rg = step(sensitivityRG,length(ALBEDO.rgb*normalize(vec3(1.0,1.0,0.0))));		//YELLOW
	float mask_rb = step(sensitivityRB,length(ALBEDO.rgb*normalize(vec3(1.0,0.0,1.0))));		//MAGENTA
	
	//MASK TEST ALBEDO = mask_rb*vec3(1.0,1.0,1.0);
	
	if(mask_gb > 0.0) {
		//Applies new color over color (0,1,1)
		float m_gb = step(sensitivityGB,length(ALBEDO.rgb*vec3(1.0,0.0,0.0)));
		ALBEDO = m_gb*ALBEDO.rgb+(1.0-m_gb)*mask_gb*new_colorGB.rgb;
		ALPHA = m_gb*ALPHA+(1.0-m_gb)*new_colorGB.a;
	}
	else if(mask_rg > 0.0) {
		//Applies new color over color (1,1,0)
		float m_rg = step(sensitivityRG,length(ALBEDO.rgb*vec3(0.0,0.0,1.0)));
		ALBEDO = m_rg*ALBEDO.rgb+(1.0-m_rg)*mask_rg*new_colorRG.rgb;
		ALPHA = m_rg*ALPHA+(1.0-m_rg)*new_colorRG.a;
	}
	else if(mask_rb > 0.0) {
		//Applies new color over color (1,0,1)
		float m_rb = step(sensitivityRB,length(ALBEDO.rgb*vec3(0.0,1.0,0.0)));
		ALBEDO = m_rb*ALBEDO.rgb+(1.0-m_rb)*mask_rb*new_colorRB.rgb;
		ALPHA = m_rb*ALPHA+(1.0-m_rb)*new_colorRB.a;
	}
	else if(mask_r > 0.0) {//(ALBEDO.rgb == vec3(0.0,1.0,0.0)) {
		//Applies new color over color (1,0,0)
		float m_r = step(sensitivityR,length(ALBEDO.rgb*vec3(0.0,1.0,1.0)));
		ALBEDO = m_r*ALBEDO.rgb+(1.0-m_r)*mask_r*new_colorR.rgb;
		ALPHA = m_r*ALPHA+(1.0-m_r)*new_colorR.a;
	}
	else if(mask_g > 0.0) {
		//Applies new color over color (0,1,0)
		float m_g = step(sensitivityG,length(ALBEDO.rgb*vec3(1.0,0.0,1.0)));
		ALBEDO = m_g*ALBEDO.rgb+(1.0-m_g)*mask_g*new_colorG.rgb;
		ALPHA = m_g*ALPHA+(1.0-m_g)*new_colorG.a;
	}
	else if(mask_b > 0.0) {
		//Applies new color over color (0,0,1)
		float m_b = step(sensitivityB,length(ALBEDO.rgb*vec3(0.0,0.0,1.0)));
		ALBEDO = m_b*ALBEDO.rgb+(1.0-m_b)*mask_b*new_colorB.rgb;
		ALPHA = m_b*ALPHA+(1.0-m_b)*new_colorB.a;
	}
}
