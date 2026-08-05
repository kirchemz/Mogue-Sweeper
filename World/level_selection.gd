extends Node2D

var level : Dictionary

func _ready() -> void:
	Levels.choose_level()

func _process(delta: float) -> void:
	level = Levels.chosen_level
	$Label.text = level.name
	$Label2.text = level.description
	$Label3.text = "Quota: " + str(Globals.level_requirement) + " Supa Moneys"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/loading_scene.tscn")
