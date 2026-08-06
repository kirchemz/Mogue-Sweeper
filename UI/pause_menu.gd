extends Control


func _on_save_and_quit_pressed() -> void:
	SaveLoad._save()
	get_tree().quit()


func _on_continue_pressed() -> void:
	get_parent().get_parent().mouse_over_menu = true
	get_parent().get_parent().get_node("Timer").paused = false
	hide()
