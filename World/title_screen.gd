extends Node2D

var start_rot
var logo_rot_up
var logo_rot_down

func _ready() -> void:
	MusicPlayer.title()
	start_rot = create_tween()
	start_rot.tween_property($TextureRect, "rotation_degrees", 3, 5)
	start_rot.play()

func _process(delta: float) -> void:
	if $TextureRect.rotation_degrees == -3:
		await get_tree().create_timer(0.25).timeout
		logo_rot_up = create_tween()
		logo_rot_up.tween_property($TextureRect, "rotation_degrees", 3, 2.5)
		logo_rot_up.play()
	if $TextureRect.rotation_degrees == 3:
		await get_tree().create_timer(0.25).timeout
		logo_rot_down = create_tween()
		logo_rot_down.tween_property($TextureRect, "rotation_degrees", -3, 2.5)
		logo_rot_down.play()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_normal_pressed() -> void:
	if FileAccess.file_exists("user://save_file.json"):
		SaveLoad._load()
	else:
		get_tree().change_scene_to_file("res://World/level_selection.tscn")
	Abilities.set_abilities = true
