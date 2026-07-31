extends Node2D

@onready var cell = preload("res://Cell/cell.tscn")
@onready var mine_scanner = preload("res://Placables/mine_scanner.tscn")

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
var mouse_over_menu : bool = false
var hide_menu : bool = false
var ui_shown : bool = false
var mine_scanner_made : bool = false
var mine_scanner_placed : bool = false
var mine_scanner_clicked : bool = false
var mine_scanner_instance

var timer_color : float = 0
var last_cam_pos = Vector2.ZERO

var time_bonus : int = 0

# Runs once as soon as the scene starts
func _ready() -> void:
	# Sets BG color
	RenderingServer.set_default_clear_color(Color(0.255, 0.573, 0.765, 1.0))
	
	# Time Bonus
	if Abilities.time_bonus:
		time_bonus += Abilities.ability_stock.time_bonus.time
	$Timer.start($Timer.wait_time + time_bonus)
	
	# Creates the map
	start_map()

# Makes the map and puts a cell in each cordinate of the map
func start_map():
	for x in map_width:
		var row : Array = []
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

# Camera panning
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			$Camera2D.position -= event.relative / $Camera2D.zoom

# Runs every frame
func _process(delta: float) -> void:
	if is_instance_valid(mine_scanner_instance):
		if mine_scanner_placed:
			mine_scanner_instance.global_position = closest_cell_to_scanner().global_position
			mine_scan(closest_cell_to_scanner())
			mine_scanner_instance.queue_free()
	if mine_scanner_made and not mine_scanner_placed:
		mine_scanner_instance.global_position = get_global_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			mine_scanner_placed = true
	if mine_scanner_clicked:
		mine_scanner_clicked = false
		mine_scanner_made = true
		mine_scanner_instance = mine_scanner.instantiate()
		add_child(mine_scanner_instance)
		mine_scanner_instance.global_position = get_global_mouse_position()
	# Makes sure the player can't click through the UI
	if ui_shown:
		mouse_over_menu = true
	
	# Update Flag Counts
	$"Camera2D/Flag 1/Label".text = "Red FLag"
	$"Camera2D/Flag 2/Label".text = "Blue FLag: " + str(Globals.blue_flags)
	$"Camera2D/Flag 3/Label".text = "Violet FLag: " + str(Globals.violet_flags)
	$"Camera2D/Flag 4/Label".text = "Orange FLag: " + str(Globals.orange_flags)
	$"Camera2D/Flag 5/Label".text = "Yellow FLag: " + str(Globals.yellow_flags)
	$"Camera2D/Flag 6/Label".text = "Green FLag: " + str(Globals.green_flags)
	$"Camera2D/Flag 7/Label".text = "Black FLag: " + str(Globals.black_flags)
	$"Camera2D/Flag 8/Label".text = "White FLag: " + str(Globals.white_flags)
	$"Camera2D/Flag 9/Label".text = "Grey FLag: " + str(Globals.grey_flags)
	$"Camera2D/Flag 10/Label".text = "Brown FLag: " + str(Globals.brown_flags)
	$"Camera2D/Flag 11/Label".text = "Magenta FLag: " + str(Globals.magenta_flags)
	$"Camera2D/Flag 12/Label".text = "Pink FLag: " + str(Globals.pink_flags)
	
	# Change the position and visibility for all UI elements in the menu when condencing it
	if hide_menu:
		$"Camera2D/Number Points".visible = false
		$"Camera2D/Ability 1".visible = false
		$"Camera2D/Ability 2".visible = false
		$"Camera2D/Ability 3".visible = false
		$"Camera2D/Ability 4".visible = false
		$"Camera2D/Ability 5".visible = false
		$"Camera2D/Point Requirement".visible = false
		$Camera2D/Mult.visible = false
		$"Camera2D/Flag 1".position = Vector2(-537 + 16, -12)
		$"Camera2D/Flag 2".position = Vector2(-446 + 16, -12)
		$"Camera2D/Flag 3".position = Vector2(-537 + 16, -91)
		$"Camera2D/Flag 4".position = Vector2(-537 + 16, 69)
		$"Camera2D/Flag 5".position = Vector2(-446 + 16, 69)
		$"Camera2D/Flag 6".position = Vector2(-446 + 16, -91)
		$"Camera2D/Flag 7".position = Vector2(-537 + 16, 147)
		$"Camera2D/Flag 8".position = Vector2(-446 + 16, 147)
		$"Camera2D/Flag 9".position = Vector2(-537 + 16, -170)
		$"Camera2D/Flag 10".position = Vector2(-537 + 16, 228)
		$"Camera2D/Flag 11".position = Vector2(-446 + 16, 228)
		$"Camera2D/Flag 12".position = Vector2(-446 + 16, -170)
		$Camera2D/NinePatchRect.position = Vector2(-556, -297)
		$Camera2D/Label.position = Vector2(-546, -310)
		$"Camera2D/Main Menu".size.x = 70
		$"Camera2D/Main Menu/Sprite2D".flip_h = true
		$"Camera2D/Main Menu/Button".position = Vector2(70, 2)
		$"Camera2D/Main Menu/Sprite2D".position = Vector2(79, 104)
		$Camera2D/Area2D/CollisionShape2D.scale.x = 0.5
		$Camera2D/Area2D/CollisionShape2D.position = Vector2(-453, -0.5)
	else:
		$"Camera2D/Number Points".visible = true
		$"Camera2D/Ability 1".visible = true
		$"Camera2D/Ability 2".visible = true
		$"Camera2D/Ability 3".visible = true
		$"Camera2D/Ability 4".visible = true
		$"Camera2D/Ability 5".visible = true
		$"Camera2D/Point Requirement".visible = true
		$Camera2D/Mult.visible = true
		$"Camera2D/Flag 1".position = Vector2(-521, 5)
		$"Camera2D/Flag 2".position = Vector2(-430, 5)
		$"Camera2D/Flag 3".position = Vector2(-342, 5)
		$"Camera2D/Flag 4".position = Vector2(-521, 85)
		$"Camera2D/Flag 5".position = Vector2(-430, 85)
		$"Camera2D/Flag 6".position = Vector2(-342, 85)
		$"Camera2D/Flag 7".position = Vector2(-521, 163)
		$"Camera2D/Flag 8".position = Vector2(-430, 163)
		$"Camera2D/Flag 9".position = Vector2(-342, 163)
		$"Camera2D/Flag 10".position = Vector2(-521, 244)
		$"Camera2D/Flag 11".position = Vector2(-430, 244)
		$"Camera2D/Flag 12".position = Vector2(-342, 244)
		$Camera2D/NinePatchRect.position = Vector2(-522, -280)
		$Camera2D/Label.position = Vector2(-512, -295)
		$"Camera2D/Main Menu".size.x = 140
		$"Camera2D/Main Menu/Button".position = Vector2(140, 2)
		$"Camera2D/Main Menu/Sprite2D".position = Vector2(148, 104)
		$"Camera2D/Main Menu/Sprite2D".flip_h = false
		$Camera2D/Area2D/CollisionShape2D.scale.x = 1
		$Camera2D/Area2D/CollisionShape2D.position = Vector2(-331, -0.5)
	
	# Update other UI elements
	$"Camera2D/Point Requirement".text = "Point Requirement: " + "
	" + str(Globals.level_requirement)
	$Camera2D/Mult.text = "Mult: " + "
	" + str(Globals.mult)
	
	# Hide specific UI elements when the game ends
	if level_over:
		hide_menu = false
		$"Camera2D/Main Menu/Button".visible = false
		$"Camera2D/Main Menu/Sprite2D".visible = false
		$Camera2D/Points.visible = true
		$"Camera2D/Flag 1".visible = false
		$"Camera2D/Flag 2".visible = false
		$"Camera2D/Flag 3".visible = false
		$"Camera2D/Flag 4".visible = false
		$"Camera2D/Flag 5".visible = false
		$"Camera2D/Flag 6".visible = false
		$"Camera2D/Flag 7".visible = false
		$"Camera2D/Flag 8".visible = false
		$"Camera2D/Flag 9".visible = false
		$"Camera2D/Flag 10".visible = false
		$"Camera2D/Flag 11".visible = false
		$"Camera2D/Flag 12".visible = false
		for y in map:
			for x in y:
				if is_instance_valid(x):
					if x.got_points:
						x.white_out()
		await get_tree().create_timer(2).timeout
	
	# Update the name and image of ability buttons
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
	
	# Update clock
	$Camera2D/Label.text = str($Timer.time_left)
	
	# Zoom in and out
	if Input.is_action_just_pressed("Zoom In") and $Camera2D.zoom < Vector2(2, 2):
		$Camera2D.zoom += Vector2(0.1, 0.1)
		$Camera2D.scale -= Vector2(0.1, 0.1)
		if snapped($Camera2D.zoom.x, 0.1) == 0.9:
			$Camera2D.scale -= Vector2(0.025, 0.025)
		if $Camera2D.zoom.x - 0.8 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.0575, 0.0575)
		if $Camera2D.zoom.x - 0.7 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.055, 0.055)
		if $Camera2D.zoom.x - 0.6 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.08, 0.08)
	if Input.is_action_just_pressed("Zoom Out") and $Camera2D.zoom > Vector2(0.5, 0.5):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
		$Camera2D.scale += Vector2(0.1, 0.1)
		if snapped($Camera2D.zoom.x, 0.1) == 0.8:
			$Camera2D.scale += Vector2(0.025, 0.025)
		if $Camera2D.zoom.x - 0.7 < 0.0000000000001:
			$Camera2D.scale += Vector2(0.0575, 0.0575)
		if $Camera2D.zoom.x - 0.6 < 0.0000000000001:
			$Camera2D.scale += Vector2(0.055, 0.055)
		if snapped($Camera2D.zoom.x, 0.1) == 0.5:
			$Camera2D.scale += Vector2(0.08, 0.08)
	
	# Setting up the cells and bombs
	if map_made:
		if bombs_made < bombs:
			set_bombs()
		else:
			if not cells_set:
				set_cells()
	# Mine Scanner Input
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Mine Scanner") and Abilities.mine_scanner:
		mine_scanner_clicked = true
		mine_scanner_placed = true
	
	# Digging, Flagging, and Chording Inputs
	if is_instance_valid(target_cell) and Input.is_action_pressed("Dig") and Input.is_action_pressed("Flag") and not mouse_over_menu:
		if not target_cell.is_hidden:
			if target_cell.flag_around() == target_cell.bombs_around:
				if target_cell.unflagged_bomb_around():
					game_over()
				target_cell.unhide_neighbors = false
				unhide_cells(target_cell)
				target_cell.unhide_neighbors = false
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Dig") and not Input.is_action_just_pressed("Flag") and not mouse_over_menu:
		if target_cell.bombs_around == 0 and not target_cell.is_bomb:
			unhide_cells(target_cell)
		if target_cell.bombs_around != 0 or target_cell.is_bomb:
			if not target_cell.flagged:
				target_cell.is_hidden = false
				if target_cell.is_bomb:
					game_over()
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Flag") and not Input.is_action_just_pressed("Dig") and not mouse_over_menu:
		if target_cell.is_hidden and not target_cell.flagged and flags_remaining > 0:
			if Levels.flags_active:
				if Globals.red_flag_active:
					target_cell.flag_type = "Red"
					target_cell.flag_tex = preload("res://Sprites/Red Flag.png")
				if Globals.blue_flag_active:
					if Globals.blue_flags > 0:
						target_cell.flag_type = "Blue"
						target_cell.flag_tex = preload("res://Sprites/Blue Flag.png")
						Globals.blue_flags -= 1
					else:
						Globals.activate_red()
				if Globals.violet_flag_active:
					target_cell.flag_type = "Purple"
					target_cell.flag_tex = preload("res://Sprites/Purple Flag.png")
					Globals.violet_flags -= 1
				if Globals.pink_flag_active:
					target_cell.flag_type = "Pink"
					target_cell.flag_tex = preload("res://Sprites/Pink Flag.png")
				if Globals.green_flag_active: 
					target_cell.flag_type = "Green"
					target_cell.flag_tex = preload("res://Sprites/Green Flag.png")
				if Globals.yellow_flag_active:
					if Globals.yellow_flags > 0:
						Globals.mult += 1
						target_cell.flag_type = "Yellow"
						target_cell.flag_tex = preload("res://Sprites/Yellow Flag.png")
						Globals.yellow_flags -= 1
					else:
						Globals.activate_red()
				if Globals.orange_flag_active:
					target_cell.flag_type = "Orange"
					target_cell.flag_tex = preload("res://Sprites/Orange Flag.png")
				if Globals.magenta_flag_active:
					target_cell.flag_type = "Magenta"
					target_cell.flag_tex = preload("res://Sprites/Magenta Flag.png")
				if Globals.black_flag_active:
					target_cell.flag_type = "Black"
					target_cell.flag_tex = preload("res://Sprites/Black Flag.png")
				if Globals.white_flag_active:
					target_cell.flag_type = "White"
					target_cell.flag_tex = preload("res://Sprites/White Flag.png")
				if Globals.grey_flag_active:
					target_cell.flag_type = "Grey"
					target_cell.flag_tex = preload("res://Sprites/Grey Flag.png")
				if Globals.brown_flag_active:
					target_cell.flag_type = "Brown"
					target_cell.flag_tex = preload("res://Sprites/Brown Flag.png")
			target_cell.flagged = true
			flags_remaining -= 1
			if Abilities.auto_chord_active:
				auto_chord(target_cell)
			return
		if target_cell.is_hidden and target_cell.flagged:
			flags_remaining += 1
			target_cell.flagged = false
	
	# Making the clock change colors as it goes down
	$Camera2D/Label.self_modulate.h = $Timer.time_left * 0.01666

# Function to place bombs throughout the cell grid
func set_bombs():
	for x in map:
		for y in x:
			if not y.is_bomb:
				if randi() % 36 == 0:
					bombs_made += 1
					y.bomb()

# Function to tell each cell how many bombs are around it
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
			cell_instance.bombs_around_set = true
	cells_set = true

# Funtion to unhide the cells around a specific cell (cell instance)
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
						if Abilities.money_sweeper:
							Abilities.casecade_count += 1
							if Abilities.casecade_count >= 4:
								Abilities.casecade_count = 0
								Globals.currency +=1
						unhide_cells(neighbor)

# Mine Scanner
func mine_scan(cell_instance):
	var repeats = Abilities.mine_scanner_level
	if cell_instance.unhide_neighbors:
		return
	cell_instance.unhide_neighbors = true
	cell_instance.scanned = true
	
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
					neighbor.scanned = true
					if neighbor.is_bomb:
						neighbor.flag_type = "Red"
						neighbor.flag_tex = preload("res://Sprites/Red Flag.png")
						neighbor.is_hidden = true
						neighbor.flagged = true
					if repeats > 0:
						unhide_scan_neighbors(neighbor, repeats - 1)
					if neighbor.bombs_around == 0 and not neighbor.is_bomb:
						unhide_cells(neighbor)

func unhide_scan_neighbors(cell_instance, repeats):
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
					neighbor.scanned = true
					if neighbor.is_bomb:
						neighbor.flag_type = "Red"
						neighbor.flag_tex = preload("res://Sprites/Red Flag.png")
						neighbor.is_hidden = true
						neighbor.flagged = true
					if repeats > 0:
						unhide_scan_neighbors(neighbor, repeats - 1)
					if neighbor.bombs_around == 0 and not neighbor.is_bomb:
						unhide_cells(neighbor)

# Function to use the ability "Auto Chording"
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

# Funtion to automatically unhide all cells around a flag - used in auto chording
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

# Funtion to end the game and change the current scene to the game over scene
func game_over():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://World/game_over.tscn")

# Function to tally up all of the points and updates the total points and the UI elements accordingly
func point_count():
	for y in map:
		for x in y:
			if is_instance_valid(x):
				x.flagged_bombs_around()
				if Abilities.double_trouble:
					if x.bombs_around == 2:
						x.flagged_bombs_around()
	Globals.points *= Globals.point_mult
	Globals.total_points = Globals.points * (Globals.mult + 1)
	Globals.currency += round(Globals.total_points * Levels.money_mult)
	Globals.total_points *= Levels.points_mult
	$Camera2D/Points.text = "Points: " + str(Globals.points) + "
	" + "X" + "
	" + "Mult:" + str(Globals.mult + 1) + "
	" + "=" + "
	" + str(Globals.total_points)

# Makes it so when you click in the menu it doesn't dig up any cells behind the menu
func _on_main_menu_mouse_entered() -> void:
	mouse_over_menu = true

func _on_main_menu_mouse_exited() -> void:
	mouse_over_menu = false

func _on_button_mouse_entered() -> void:
	mouse_over_menu = true

func _on_button_mouse_exited() -> void:
	mouse_over_menu = false

func _on_button_pressed() -> void:
	mouse_over_menu = true
	if not hide_menu:
		hide_menu = true
		return
	if hide_menu:
		hide_menu = false

# When the timer ends it counts up the points and figures out if you won or lost
func _on_timer_timeout() -> void:
	point_count()
	level_over = true
	if Globals.total_points < Globals.level_requirement:
		await get_tree().create_timer(4).timeout
		game_over()
	else:
		$Camera2D/TextureButton.visible = true
		Globals.points = 0

# Takes you to the shop when pressing the shop button
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/shop.tscn")

# Toggles the first ability
func _on_ability_1_pressed() -> void:
	if Abilities.ability_one.name == "Auto Chord":
		Abilities.auto_chord_active = true

func _on_ability_2_pressed() -> void:
	if Abilities.ability_two.name == "Auto Chord":
		Abilities.auto_chord_active = true

func _on_ability_3_pressed() -> void:
	if Abilities.ability_three.name == "Auto Chord":
		Abilities.auto_chord_active = true

func _on_ability_4_pressed() -> void:
	if Abilities.ability_four.name == "Auto Chord":
		Abilities.auto_chord_active = true

func _on_ability_5_pressed() -> void:
	if Abilities.ability_five.name == "Auto Chord":
		Abilities.auto_chord_active = true

# Changes which flag you are currently using
func _on_flag_1_pressed() -> void:
	Globals.activate_red()

func _on_flag_2_pressed() -> void:
	if Globals.blue_flags > 0:
		Globals.activate_blue()

func _on_flag_3_pressed() -> void:
	Globals.activate_violet()

func _on_flag_12_pressed() -> void:
	Globals.activate_pink()

func _on_flag_6_pressed() -> void:
	Globals.activate_green()

func _on_flag_5_pressed() -> void:
	Globals.activate_yellow()

func _on_flag_4_pressed() -> void:
	Globals.activate_orange()

func _on_flag_11_pressed() -> void:
	Globals.activate_magenta()

func _on_flag_7_pressed() -> void:
	Globals.activate_black()

func _on_flag_8_pressed() -> void:
	Globals.activate_white()

func _on_flag_9_pressed() -> void:
	Globals.activate_grey()

func _on_flag_10_pressed() -> void:
	Globals.activate_brown()

func _on_number_points_pressed() -> void:
	ui_shown = true
	$Timer.paused = true
	$"Camera2D/Number Points UI".visible = true
	mouse_over_menu = true
	hide_menu = false


func _on_ability_1_button_down() -> void:
	if not mine_scanner_made:
		mouse_over_menu = true
		mine_scanner_clicked = true


func _on_ability_1_button_up() -> void:
	mouse_over_menu = false
	mine_scanner_placed = true

func closest_cell_to_scanner():
	var closest
	var dist = INF
	for child in $BoxContainer.get_children():
		if mine_scanner_instance.global_position.distance_to(child.global_position) < dist:
			dist = mine_scanner_instance.global_position.distance_to(child.global_position)
			closest = child
	
	return closest
