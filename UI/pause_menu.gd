extends Control

func _ready() -> void:
	$NinePatchRect3/Master.value = SaveLoad.data.volume
	$NinePatchRect3/Music.value = SaveLoad.data.music_volume
	$NinePatchRect3/SFX.value = SaveLoad.data.sfx_volume

func _on_save_and_quit_pressed() -> void:
	if get_tree().current_scene.scene_file_path != "res://World/title_screen.tscn" and get_tree().current_scene.scene_file_path != "res://World/tutorial.tscn" and get_tree().current_scene.scene_file_path != "res://World/game_over.tscn" and get_tree().current_scene.scene_file_path != "res://World/level_selection.tscn":
		SaveLoad._save()
	get_tree().quit()

func _on_continue_pressed() -> void:
	if get_parent() is Camera2D:
		get_parent().get_parent().mouse_over_menu = true
		get_parent().get_parent().get_node("Timer").paused = false
	hide()

func _on_settings_pressed() -> void:
	$NinePatchRect.hide()
	$NinePatchRect3.show()

func _on_h_slider_value_changed(value: float) -> void:
	var master_bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func _on_sfx_value_changed(value: float) -> void:
	var master_bus := AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func _on_music_value_changed(value: float) -> void:
	var master_bus := AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))


func _on_button_pressed() -> void:
	$NinePatchRect3.hide()
	$NinePatchRect.show()
