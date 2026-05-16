shader_type canvas_item;

uniform float threshold = 150;
uniform float alpha = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE, UV);
	
	float maxC = max(color.r, max(color.g, color.b));
	float minC = min(color.r, min(color.g, color.b));
	if (maxC - minC < threshold && maxC < 0.8) {
		color.a = 0.0;
	}
	else {
		color.a = alpha;
	}
	
	COLOR = color;
}
