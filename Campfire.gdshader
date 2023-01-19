shader_type canvas_item;

uniform vec4 bg_col: source_color = vec4(1.0f);
uniform vec4 fg_col: source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);

void fragment() {
	if (COLOR.r == 1.0f) {
		COLOR = bg_col;
	}
	if (COLOR.r == 0.0f) {
		COLOR = fg_col;
	}
}
