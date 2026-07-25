extends Node2D

@onready var cell = preload("res://Cell/cell.tscn")

var map : Array = []
var map_width : int = 40
var map_height : int = 40
var bombs : int = 120
var bombs_made : int = 0
var map_made : bool = false
var cells_set : bool = false
var target_cell
var flags_remaining : int = bombs
var level_over : bool = false

var timer_color : float = 0
var last_cam_pos = Vector2.ZERO

func _ready() -> void:
	start_map()

func start_map():
	for x in map_width:
		var row := []
		for y in map_height:
			row.append(0)
		map.append(row)
	for x in map_width:
		for y in map_height:
			var cell_instance = cell.instantiate()
			cell_instance.global_position.y = y * 16
			cell_instance.global_position.x = x * 16
			$BoxContainer.add_child(cell_instance)
			map[x][y] = cell_instance
	map_made = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			$Camera2D.position -= event.relative / $Camera2D.zoom

func _process(delta: float) -> void:
	$Camera2D/Mult2.text = str(Globals.points)
	$"Camera2D/Point Requirement".text = "Point Requirement: " + str(Globals.level_requirement)
	$Camera2D/Mult.text = "Mult: " + str(Globals.mult)
	if level_over:
		$Camera2D/Points.visible = true
	$"Camera2D/Ability 1/Label".text = Abilities.ability_one.name
	$"Camera2D/Ability 1".texture_normal = Abilities.ability_one.img
	$"Camera2D/Ability 2/Label".text = Abilities.ability_two.name
	$"Camera2D/Ability 2".texture_normal = Abilities.ability_two.img
	$"Camera2D/Ability 3/Label".text = Abilities.ability_three.name
	$"Camera2D/Ability 3".texture_normal = Abilities.ability_three.img
	$"Camera2D/Ability 4/Label".text = Abilities.ability_four.name
	$"Camera2D/Ability 4".texture_normal = Abilities.ability_four.img
	$"Camera2D/Ability 5/Label".text = Abilities.ability_five.name
	$"Camera2D/Ability 5".texture_normal = Abilities.ability_five.img
	$Camera2D/HBoxContainer/Label.text = str($Timer.time_left)
	if Input.is_action_just_pressed("Zoom In") and $Camera2D.zoom < Vector2(5, 5):
		$Camera2D.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("Zoom Out") and $Camera2D.zoom > Vector2(0.5, 0.5):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
	
	if map_made:
		if bombs_made < bombs:
			set_bombs()
		else:
			if not cells_set:
				set_cells()
	if is_instance_valid(target_cell) and Input.is_action_pressed("Dig") and Input.is_action_pressed("Flag"):
		if not target_cell.is_hidden:
			if target_cell.flag_around() == target_cell.bombs_around:
				if target_cell.unflagged_bomb_around():
					game_over()
				target_cell.unhide_neighbors = false
				unhide_cells(target_cell)
				target_cell.unhide_neighbors = false
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Dig") and not Input.is_action_just_pressed("Flag"):
		if target_cell.bombs_around == 0 and not target_cell.is_bomb:
			unhide_cells(target_cell)
		if target_cell.bombs_around != 0 or target_cell.is_bomb:
			if not target_cell.flagged:
				target_cell.is_hidden = false
				if target_cell.is_bomb:
					game_over()
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Flag") and not Input.is_action_just_pressed("Dig"):
		if target_cell.is_hidden and not target_cell.flagged and flags_remaining > 0:
			if Globals.red_flag_active:
				target_cell.flag_type = "Red"
				target_cell.flag_tex = preload("res://Sprites/Red Flag.png")
			if Globals.blue_flag_active:
				target_cell.flag_type = "Blue"
				target_cell.flag_tex = preload("res://Sprites/Blue Flag.png")
			if Globals.purple_flag_active:
				target_cell.flag_type = "Purple"
				target_cell.flag_tex = preload("res://Sprites/Purple Flag.png")
			target_cell.flagged = true
			flags_remaining -= 1
			if Abilities.auto_chord_active:
				auto_chord(target_cell)
			return
		if target_cell.is_hidden and target_cell.flagged:
			flags_remaining += 1
			target_cell.flagged = false
	
	$Camera2D/HBoxContainer/Label.self_modulate.h = $Timer.time_left * 0.01666

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
	cells_set = true

func unhide_cells(cell_instance):
	if cell_instance.unhide_neighbors:
		return
	cell_instance.unhide_neighbors = true
	cell_instance.is_hidden = false
	
	var xc = -1
	var yc = -1
	for y in range(map_height):
		for x in range(map_width):
			if map[x][y] == cell_instance:
				xc = x
				yc = y
	
	if xc == -1 or yc == -1:
		return
	
	for ay in range(-1, 2):
		for ax in range(-1, 2):
			var check_x = xc + ax
			var check_y = yc + ay
			if check_x >= 0 and check_x < map_width and check_y >= 0 and check_y < map_height:
				var neighbor = map[check_x][check_y]
				if is_instance_valid(neighbor) and neighbor.is_hidden:
					neighbor.is_hidden = false
					if not neighbor.is_bomb:
						neighbor.flagged = false
					if not cell_instance.unflagged_bomb_around() and neighbor.is_bomb:
						neighbor.is_hidden = true
					if neighbor.bombs_around == 0 and not neighbor.is_bomb:
						unhide_cells(neighbor)

func auto_chord(cell_instance):
	if not cell_instance.is_bomb:
		game_over()
	if cell_instance.unhide_neighbors:
		return
	cell_instance.unhide_neighbors = true
	cell_instance.is_hidden = true
	
	var xc = -1
	var yc = -1
	for y in range(map_height):
		for x in range(map_width):
			if map[x][y] == cell_instance:
				xc = x
				yc = y
	
	if xc == -1 or yc == -1:
		return
	
	for ay in range(-1, 2):
		for ax in range(-1, 2):
			var check_x = xc + ax
			var check_y = yc + ay
			if check_x >= 0 and check_x < map_width and check_y >= 0 and check_y < map_height:
				var neighbor = map[check_x][check_y]
				if is_instance_valid(neighbor):
					if not neighbor.is_hidden and not neighbor.is_bomb:
						unhide_flag_neighbors(neighbor)

func unhide_flag_neighbors(cell_instance):
	if cell_instance.unhide_neighbors:
		return
	cell_instance.unhide_neighbors = true
	cell_instance.is_hidden = false
	
	var xc = -1
	var yc = -1
	for y in range(map_height):
		for x in range(map_width):
			if map[x][y] == cell_instance:
				xc = x
				yc = y
	
	if xc == -1 or yc == -1:
		return
	
	for ay in range(-1, 2):
		for ax in range(-1, 2):
			var check_x = xc + ax
			var check_y = yc + ay
			if check_x >= 0 and check_x < map_width and check_y >= 0 and check_y < map_height:
				var neighbor = map[check_x][check_y]
				if is_instance_valid(neighbor) and neighbor.is_hidden:
					if not neighbor.is_bomb:
						neighbor.is_hidden = false
						neighbor.flagged = false

func game_over():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://World/game_over.tscn")

func point_count():
	for y in map:
		for x in y:
			if is_instance_valid(x):
				x.flagged_bombs_around()
	Globals.points *= Globals.point_mult
	Globals.total_points = Globals.points * (Globals.mult + 1)
	$Camera2D/Points.text = "Points: " + str(Globals.points) + " X " + "Mult: " + str(Globals.mult + 1) + " = " + str(Globals.total_points)
	$Camera2D/NinePatchRect.size.x += ($Camera2D/Points.get_total_character_count() * 22)

func _on_timer_timeout() -> void:
	point_count()
	level_over = true
	if Globals.total_points < Globals.level_requirement:
		await get_tree().create_timer(4).timeout
		game_over()
	else:
		$Camera2D/TextureButton.visible = true
		Globals.currency += Globals.points
		Globals.points = 0

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/shop.tscn")

func _on_ability_1_pressed() -> void:
	if Abilities.ability_one.name == "Auto Chord":
		Abilities.auto_chord_active = true
