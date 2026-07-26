extends TextureButton

var og_scale = scale

func _on_button_down() -> void:
	scale -= Vector2(0.4, 0.4)

func _on_button_up() -> void:
	scale = og_scale
