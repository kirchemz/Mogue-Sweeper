extends Node2D

@onready var cell = preload("res://Cell/cell.tscn")
@onready var mine_scanner = preload("res://Placables/mine_scanner.tscn")
@onready var explosion = preload("res://Misc/explosion.tscn")

var cell_box = BoxContainer.new()
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
var money_gained : int = 0
var added_mult : bool = false

var timer_color : float = 0
var last_cam_pos = Vector2.ZERO

var time_bonus : int = 0

# Runs once as soon as the scene starts
func _ready() -> void:
	$"Camera2D/Level Details/Label".text = Levels.chosen_level.name
	$"Camera2D/Level Details/Label2".text = Levels.chosen_level.description
	$"Camera2D/Level Details/Label3".text = Levels.chosen_level.plot_description

	Abilities.casecade_count = 0
	Abilities.special_flag_count = 0
	Abilities.numbers_used.clear()
	Abilities.first_click = false
	Globals.cascade_click = false
	Abilities.three_mult = 1
	
	MusicPlayer.world()
	
	$Timer.wait_time = $Timer.wait_time * Levels.time_mult
	
	# Sets BG color
	RenderingServer.set_default_clear_color(Color(0.561, 0.592, 0.29, 1.0))
	
	# Time Bonus
	if Abilities.mowl_time:
		time_bonus += Abilities.ability_stock.mowl_time.time
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
			cell_instance.global_position.y = y * 32
			cell_instance.global_position.x = x * 32
			cell_box.add_child(cell_instance)
			map[x][y] = cell_instance
	add_child(cell_box)
	move_child(cell_box, 0)
	map_made = true

# Camera panning
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			$Camera2D.position -= event.relative / $Camera2D.zoom

# Runs every frame
func _process(_delta: float) -> void:
	$Camera2D/NinePatchRect2/Label.text = "Supa Money: "  + str(Globals.currency)
	if Quests.current_quests.size() > 0:
		$"Camera2D/Quest Board/Quest 1".text = Quests.current_quests[0].quest_board_description
		$"Camera2D/Quest Board/Quest 1 Details".text = "Reward: "  + str(Quests.current_quests[0].reward) + "    Time: " + str(Quests.current_quests[0].time) + " Rounds"
	if Quests.current_quests.size() > 1:
		$"Camera2D/Quest Board/Quest 2".text = Quests.current_quests[1].quest_board_description
		$"Camera2D/Quest Board/Quest 2 Details".text = "Reward: "  + str(Quests.current_quests[1].reward) + "    Time: " + str(Quests.current_quests[1].time) + " Rounds"
	if Quests.current_quests.size() > 2:
		$"Camera2D/Quest Board/Quest 3".text = Quests.current_quests[2].quest_board_description
		$"Camera2D/Quest Board/Quest 3 Details".text = "Reward: "  + str(Quests.current_quests[2].reward) + "    Time: " + str(Quests.current_quests[2].time) + " Rounds"
	if Input.is_action_just_pressed("Pause"):
		$"Camera2D/Pause Menu".show()
		$Timer.paused = true
	if Abilities.slow_mowl:
		slow_mode()
	if Abilities.fast_mowl:
		fast_mode()
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
		$"Camera2D/Sprite2D".flip_h = true
		$"Camera2D/Main Menu".position.x = -7211.0
		$"Camera2D/Button".position = Vector2(-347, -366)
		$"Camera2D/Sprite2D".position = Vector2(-324, -6)
		$Camera2D/Area2D/CollisionShape2D.scale.x = 0.5
		$Camera2D/Area2D/CollisionShape2D.position = Vector2(-3628, 210.5)
		$"Camera2D/Level Details".hide()
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
		$"Camera2D/Main Menu".position.x = -7011.0
		$"Camera2D/Button".position = Vector2(-149, -366)
		$"Camera2D/Sprite2D".position = Vector2(-123, -6)
		$"Camera2D/Sprite2D".flip_h = false
		$"Camera2D/Level Details".show()
		$Camera2D/Area2D/CollisionShape2D.scale.x = 1
		$Camera2D/Area2D/CollisionShape2D.position = Vector2(-3530, 210.5)
	
	# Update other UI elements
	$"Camera2D/Point Requirement".text = "Quota: " + "
	" + str(Globals.level_requirement) + " Supa Moneys"
	$Camera2D/Mult.text = "Mult: " + "
	" + str(Globals.mult)
	
	# Hide specific UI elements when the game ends
	if level_over:
		hide_menu = false
		$"Camera2D/Button".visible = false
		$"Camera2D/Sprite2D".visible = false
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
	$Camera2D/Label.visible_characters = 2
	
	# Zoom in and out
	if Input.is_action_just_pressed("Zoom In") and $Camera2D.zoom < Vector2(1, 1):
		$Camera2D.zoom += Vector2(0.1, 0.1)
		$Camera2D.scale -= Vector2(0.1, 0.1)
		if $Camera2D.zoom.x - 0.9 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.03, 0.03)
		if $Camera2D.zoom.x - 0.8 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.0575, 0.0575)
		if $Camera2D.zoom.x - 0.7 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.055, 0.055)
		if $Camera2D.zoom.x - 0.6 < 0.0000000000001:
			$Camera2D.scale -= Vector2(0.08, 0.08)
	if Input.is_action_just_pressed("Zoom Out") and $Camera2D.zoom > Vector2(0.5, 0.5):
		$Camera2D.zoom -= Vector2(0.1, 0.1)
		if not $Camera2D.zoom.x - 0.8 < 0.0000000000001:
			$Camera2D.scale += Vector2(0.01, 0.01)
		if not $Camera2D.zoom.x - 0.7 < 0.0000000000001:
			$Camera2D.scale += Vector2(0.0575, 0.0575)
		if not $Camera2D.zoom.x - 0.6 < 0.0000000000001:
			$Camera2D.scale += Vector2(0.055, 0.055)
		if not $Camera2D.zoom.x - 0.5 < 0.0000000000001:
			$Camera2D.scale += Vector2(0.08, 0.08)
	
	# Setting up the cells and bombs
	if map_made:
		if bombs_made < bombs:
			set_bombs()
		else:
			if not cells_set:
				set_cells()
	# Mine Scanner Input
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Mine Scanner") and Abilities.owl:
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
				target_cell.clicked = true
				target_cell.is_hidden = false
				if target_cell.is_bomb:
					game_over()
	if is_instance_valid(target_cell) and Input.is_action_just_pressed("Flag") and not Input.is_action_just_pressed("Dig") and not mouse_over_menu:
		if target_cell.is_hidden and not target_cell.flagged and flags_remaining > 0:
			if Levels.flags_active:
				if Globals.red_flag_active:
					target_cell.flag_type = "Red"
				if Globals.blue_flag_active:
					if Globals.blue_flags > 0:
						target_cell.flag_type = "Blue"
						Globals.blue_flags -= 1
					else:
						Globals.activate_red()
				if Globals.violet_flag_active:
					target_cell.flag_type = "Purple"
					Globals.violet_flags -= 1
				if Globals.pink_flag_active:
					target_cell.flag_type = "Pink"
				if Globals.green_flag_active: 
					target_cell.flag_type = "Green"
				if Globals.yellow_flag_active:
					if Globals.yellow_flags > 0:
						Globals.mult += 1
						added_mult = true
						if Abilities.mowl_flags_again:
							Globals.mult += 1
						target_cell.flag_type = "Yellow"
						Globals.yellow_flags -= 1
					else:
						Globals.activate_red()
				if Globals.orange_flag_active:
					target_cell.flag_type = "Orange"
				if Globals.magenta_flag_active:
					target_cell.flag_type = "Magenta"
				if Globals.black_flag_active:
					target_cell.flag_type = "Black"
				if Globals.white_flag_active:
					target_cell.flag_type = "White"
				if Globals.grey_flag_active:
					target_cell.flag_type = "Grey"
				if Globals.brown_flag_active:
					target_cell.flag_type = "Brown"
			target_cell.flagged = true
			flags_remaining -= 1
			if Abilities.auto_chord_active:
				auto_chord(target_cell)
			return
		if target_cell.is_hidden and target_cell.flagged:
			target_cell.dug_up = false
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
			if Abilities.one_mowl:
				cell_instance.acting_number_bonus += 1
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
					if neighbor.bombs_around != 0 and not neighbor.is_bomb:
						neighbor.clicked = true
					neighbor.is_hidden = false
					if not neighbor.is_bomb:
						neighbor.flagged = false
					if not cell_instance.unflagged_bomb_around() and neighbor.is_bomb:
						neighbor.is_hidden = true
					if neighbor.bombs_around == 0 and not neighbor.is_bomb:
						if not Globals.cascade_click:
							Globals.cascade_click = true
						if Abilities.first_try and Abilities.first_click:
							Globals.currency += 100
						if Abilities.mowl_cascade:
							Abilities.casecade_count += 1
							if Abilities.casecade_count >= 4:
								Abilities.casecade_count = 0
								Globals.currency +=1
						Abilities.first_click = false
						unhide_cascade(neighbor)

func unhide_cascade(cell_instance):
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
						if not Globals.cascade_click:
							Globals.cascade_click = true
						if Abilities.first_try and Abilities.first_click:
							Globals.currency += 100
						if Abilities.mowl_cascade:
							Abilities.casecade_count += 1
							if Abilities.casecade_count >= 4:
								Abilities.casecade_count = 0
								Globals.currency +=1
						Abilities.first_click = false
						unhide_cascade(neighbor)

# Mine Scanner
func mine_scan(cell_instance):
	var repeats = Abilities.owl_level
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
	Levels.death_level = Levels.chosen_level
	Levels.died = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://World/game_over.tscn")

# Function to tally up all of the points and updates the total points and the UI elements accordingly
func point_count():
	for y in map:
		for x in y:
			if is_instance_valid(x):
				x.flagged_bombs_around()
				if Abilities.greedy_mowl:
					if x.bombs_around == 2:
						x.flagged_bombs_around()
	if Abilities.low_scorer:
		if not 3 in Abilities.numbers_used and not 4 in Abilities.numbers_used and not 5 in Abilities.numbers_used and not 6 in Abilities.numbers_used and not 7 in Abilities.numbers_used and not 8 in Abilities.numbers_used and not 9 in Abilities.numbers_used:
			Globals.mult *= 2
	if Abilities.one_two_three_four_five:
		if 1 in Abilities.numbers_used and 2 in Abilities.numbers_used and 3 in Abilities.numbers_used and 4 in Abilities.numbers_used and 5 in Abilities.numbers_used:
			Globals.mult *= 5
	if Quests.one_through_five:
		if 1 in Abilities.numbers_used and 2 in Abilities.numbers_used and 3 in Abilities.numbers_used and 4 in Abilities.numbers_used and 5 in Abilities.numbers_used:
			Quests.current_quests[Quests.current_quests.find(Quests.quests.one_through_five)].completed = true
	if Abilities.mowl_abilities:
		for ability in Abilities.current_abilities:
			if "type" in ability:
				if ability.type == "MOWL":
					Globals.mult *= 1.5
	Globals.mult *= Abilities.three_mult
	Globals.points *= Globals.point_mult
	Globals.mult *= Abilities.special_flag_count + 1
	Globals.total_points = Globals.points * (Globals.mult)
	if Abilities.high_scorer:
		if not 1 in Abilities.numbers_used and not 2 in Abilities.numbers_used:
			Globals.total_points *= 4
	$Camera2D/Points.text = "Points: " + str(Globals.points) + "
	" + "X" + "
	" + "Mult:" + str(Globals.mult) + "
	" + "=" + "
	" + str(Globals.total_points)
	if Quests.fifty_quota:
		for i in range(Globals.level_requirement - 50, Globals.level_requirement + 50):
			if Globals.total_points == i:
				Quests.current_quests[Quests.current_quests.find(Quests.quests.fifty_quota)].completed = true
	if Quests.one_thousand_dollas:
		Quests.total_money += money_gained
	if Quests.no_mult:
		if not added_mult:
			Quests.current_quests[Quests.current_quests.find(Quests.quests.no_mult)].completed = true

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
	if Abilities.active_bomb:
		await get_tree().create_timer(2).timeout
		var probabilities : Array = []
		for one in Levels.probability_mult:
			probabilities.append("Explode")
		while probabilities.size() < 50:
			probabilities.append("Nothing")
		randomize()
		if probabilities[randi() % probabilities.size()] == "Explode":
			if Abilities.ability_one == Abilities.ability_stock.active_bomb:
				Abilities.self_destruct(1)
				var explosion_instance = explosion.instantiate()
				explosion_instance.global_position = $"Camera2D/Ability 1".global_position
				add_child(explosion_instance)
			if Abilities.ability_two == Abilities.ability_stock.active_bomb:
				Abilities.self_destruct(2)
				var explosion_instance = explosion.instantiate()
				explosion_instance.global_position = $"Camera2D/Ability 2".global_position + Vector2(32, 32)
				add_child(explosion_instance)
			if Abilities.ability_three == Abilities.ability_stock.active_bomb:
				Abilities.self_destruct(3)
				var explosion_instance = explosion.instantiate()
				explosion_instance.global_position = $"Camera2D/Ability 3".global_position + Vector2(32, 32)
				add_child(explosion_instance)
			if Abilities.ability_four == Abilities.ability_stock.active_bomb:
				Abilities.self_destruct(4)
				var explosion_instance = explosion.instantiate()
				explosion_instance.global_position = $"Camera2D/Ability 4".global_position + Vector2(32, 32)
				add_child(explosion_instance)
			if Abilities.ability_five == Abilities.ability_stock.active_bomb:
				Abilities.self_destruct(5)
				var explosion_instance = explosion.instantiate()
				explosion_instance.global_position = $"Camera2D/Ability 5".global_position + Vector2(32, 32)
				add_child(explosion_instance)

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
	if Abilities.owl:
		if not mine_scanner_made:
			mouse_over_menu = true
			mine_scanner_clicked = true


func _on_ability_1_button_up() -> void:
	if Abilities.owl:
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

func slow_mode():
	$Camera2D/Label.text = str($Timer.time_left)
	Engine.time_scale = 0.5
	await get_tree().create_timer(5).timeout
	Abilities.slow_mowl = false
	Engine.time_scale = 1

func fast_mode():
	$Camera2D/Label.text = str($Timer.time_left)
	Engine.time_scale = 2
	await get_tree().create_timer(5).timeout
	Abilities.fast_mowl = false
	Engine.time_scale = 1
