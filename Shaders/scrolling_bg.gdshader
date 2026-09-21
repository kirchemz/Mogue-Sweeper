shader_type canvas_item;

uniform vec2 offset = vec2(1.0, -1.0);

void vertex() {
	UV = UV + offset * TIME;
}
