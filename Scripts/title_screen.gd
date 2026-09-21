extends Node2D

@onready var cell = preload("res://Cell/cell.tscn")
@onready var cell_box = $BoxContainer

var map : Array = []
var map_width : int = 23
var map_height : int = 14
var bombs : int = 120
var bombs_made : int = 0
var map_made : bool = false
var cells_set : bool = false
var start_rot
var logo_rot_up
var logo_rot_down
var mouse_over_menu : bool = false
var target_cell

func _ready() -> void:
	if FileAccess.file_exists("user://save_file.json"):
		$Continue.show()
	else:
		$Continue.hide()
	MusicPlayer.title()
	start_rot = create_tween()
	start_rot.tween_property($TextureRect, "rotation_degrees", 3, 5)
	start_rot.play()
	start_map()

func _process(_delta: float) -> void:
	# Setting up the cells and bombs
	if map_made:
		if bombs_made < bombs:
			set_bombs()
		else:
			if not cells_set:
				set_cells()
	
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
		$Warning.show()
	else:
		get_tree().change_scene_to_file("res://World/level_selection.tscn")
	Abilities.set_abilities = true


func _on_tutorial_pressed() -> void:
	print("HI")
	Levels.tutorial = true
	get_tree().change_scene_to_file("res://World/level_selection.tscn")


func _on_continue_pressed() -> void:
	if FileAccess.file_exists("user://save_file.json"):
		SaveLoad._load()


func _on_yes_pressed() -> void:
	SaveLoad.clear()
	get_tree().change_scene_to_file("res://World/level_selection.tscn")


func _on_no_pressed() -> void:
	$Warning.hide()

func start_map():
	for x in map_width:
		var row : Array = []
		for y in map_height:
			row.append(0)
		map.append(row)
	for x in map_width:
		for y in map_height:
			var cell_instance = cell.instantiate()
			cell_instance.global_position.y = y * 32
			cell_instance.global_position.x = x * 32
			cell_box.add_child(cell_instance)
			map[x][y] = cell_instance
	add_child(cell_box)
	move_child(cell_box, 0)
	map_made = true

func set_bombs():
	for x in map:
		for y in x:
			if not y.is_bomb:
				if randi() % 36 == 0:
					bombs_made += 1
					y.bomb()

func set_cells():
	for y in range(map_height):
		for x in range(map_width):
			var cell_instance = map[x][y]
			cell_instance.is_hidden = false
			if cell_instance.is_bomb:
				continue
			
			for ay in range(-1, 2):
				for ax in range(-1, 2):
					if ax == 0 and ay == 0:
						continue
					
					var check_x = x + ax
					var check_y = y + ay
					
					if check_x >= 0 and check_x < map_width and check_y >= 0 and check_y < map_height:
						if map[check_x][check_y].is_bomb:
							cell_instance.bombs_around += 1
			cell_instance.bombs_around_set = true
			if Abilities.one_mowl:
				cell_instance.acting_number_bonus += 1
	cells_set = true


func _on_normal_mouse_entered() -> void:
	$Normal/NinePatchRect.show()


func _on_normal_mouse_exited() -> void:
	$Normal/NinePatchRect.hide()


func _on_continue_mouse_entered() -> void:
	$Continue/NinePatchRect.show()


func _on_continue_mouse_exited() -> void:
	$Continue/NinePatchRect.hide()


func _on_story_mouse_entered() -> void:
	$Story/NinePatchRect.show()


func _on_story_mouse_exited() -> void:
	$Story/NinePatchRect.hide()


func _on_tutorial_mouse_entered() -> void:
	$Tutorial/NinePatchRect.show()


func _on_tutorial_mouse_exited() -> void:
	$Tutorial/NinePatchRect.hide()


func _on_quit_mouse_entered() -> void:
	$Quit/NinePatchRect.show()


func _on_quit_mouse_exited() -> void:
	$Quit/NinePatchRect.hide()


func _on_yes_mouse_entered() -> void:
	$Warning/NinePatchRect/Yes/NinePatchRect.show()


func _on_yes_mouse_exited() -> void:
	$Warning/NinePatchRect/Yes/NinePatchRect.hide()


func _on_no_mouse_entered() -> void:
	$Warning/NinePatchRect/No/NinePatchRect.show()


func _on_no_mouse_exited() -> void:
	$Warning/NinePatchRect/No/NinePatchRect.hide()


func _on_mista_mowl_2_mouse_entered() -> void:
	$"Mista Mowl".play("idle")


func _on_mista_mowl_2_mouse_exited() -> void:
	$"Mista Mowl".play("default")


func _on_ms_mowl_2_mouse_entered() -> void:
	$"Ms Mowl".play("idle")


func _on_ms_mowl_2_mouse_exited() -> void:
	$"Ms Mowl".play("default")


func _on_only_son_2_mouse_entered() -> void:
	$"Only Son".play("idle")


func _on_only_son_2_mouse_exited() -> void:
	$"Only Son".play("default")


func _on_cousin_derick_2_mouse_entered() -> void:
	$"Cousin Derick".play("idle")


func _on_cousin_derick_2_mouse_exited() -> void:
	$"Cousin Derick".play("default")


func _on_cousin_daisy_2_mouse_entered() -> void:
	$"Cousin Daisy".play("idle")


func _on_cousin_daisy_2_mouse_exited() -> void:
	$"Cousin Daisy".play("default")


func _on_ancklebiter_2_mouse_entered() -> void:
	$"Ancklebiter".play("idle")


func _on_ancklebiter_2_mouse_exited() -> void:
	$"Ancklebiter".play("default")


func _on_bramble_2_mouse_entered() -> void:
	$"Bramble".play("idle")


func _on_bramble_2_mouse_exited() -> void:
	$"Bramble".play("default")


func _on_angrylookinmowl_2_mouse_entered() -> void:
	$"Angrylookinmowl".play("idle")


func _on_angrylookinmowl_2_mouse_exited() -> void:
	$"Angrylookinmowl".play("default")


func _on_remy_2_mouse_entered() -> void:
	$"Remy".play("idle")


func _on_remy_2_mouse_exited() -> void:
	$"Remy".play("default")


func _on_uncle_jimmy_2_mouse_entered() -> void:
	$"Uncle Jimmy".play("idle")


func _on_uncle_jimmy_2_mouse_exited() -> void:
	$"Uncle Jimmy".play("default")
