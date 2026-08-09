extends Node2D

var level : Dictionary

func _ready() -> void:
	if not Levels.first_load or Levels.chosen_level == null:
		Levels.choose_level()
	Levels.first_load = false

func _process(_delta: float) -> void:
	level = Levels.chosen_level
	$Label.text = level.name
	$Label2.text = level.description
	$Label3.text = "Quota: " + str(Globals.level_requirement) + " Supa Moneys"
	$Label4.text = level.plot_description


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/loading_scene.tscn")
