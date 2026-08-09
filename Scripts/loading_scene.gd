extends Node2D

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.0, 0.0, 0.0, 1.0))
	if Levels.tutorial:
		get_tree().change_scene_to_file("res://World/tutorial.tscn")
	else:
		get_tree().change_scene_to_file("res://World/world.tscn")
