extends TextureButton

var og_scale = scale

func _on_button_down() -> void:
	scale -= scale / 8

func _on_button_up() -> void:
	scale = og_scale
