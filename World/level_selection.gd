extends Node2D

var level : Dictionary

func _ready() -> void:
	Levels.choose_level()

func _process(delta: float) -> void:
	level = Levels.chosen_level
	$Label.text = level.name
	$Label2.text = level.description
	$Label3.text = "Point Requirements: " + str(Globals.level_requirement)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")
