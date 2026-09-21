extends Node2D

func _ready() -> void:
	if not Levels.first_load or Levels.chosen_level == null:
		Levels.choose_level()
	Levels.first_load = false

func _process(_delta: float) -> void:
	$Label.text = Levels.chosen_level.name
	$Label2.text = Levels.chosen_level.description
	$Label3.text = "Quota: " + str(Globals.level_requirement)
	$Label4.text = Levels.chosen_level.plot_description


func _on_button_pressed() -> void:
	if Levels.tutorial:
		get_tree().change_scene_to_file("res://World/tutorial.tscn")
	else:
		get_tree().change_scene_to_file("res://World/world.tscn")


func _on_button_mouse_entered() -> void:
	$Button/NinePatchRect.show()


func _on_button_mouse_exited() -> void:
	$Button/NinePatchRect.hide()
