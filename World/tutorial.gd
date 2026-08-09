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

var dialogue_section : int = 1
var dialogue_open : bool = false

var timer_color : float = 0
var last_cam_pos = Vector2.ZERO

var time_bonus : int = 0

# Runs once as soon as the scene starts
func _ready() -> void:
	Abilities.casecade_count = 0
	Abilities.special_flag_count = 0
	Abilities.numbers_used.clear()
	Abilities.first_click = false
	Abilities.three_mult = 1
	
	MusicPlayer.world()
	
	$Timer.wait_time = $Timer.wait_time * Levels.time_mult
	
	# Sets BG color
	RenderingServer.set_default_clear_color(Color(0.561, 0.592, 0.29, 1.0))
	
	$Timer.wait_time = $Timer.wait_time + time_bonus
	$Camera2D/Label.text = "60"
	
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
func _process(delta: float) -> void:
	if dialogue_open:
		if not $"Camera2D/Dialogue Box/NinePatchRect/Label".visible_ratio == 1:
			$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters += 1
			$"Camera2D/Dialogue Box/NinePatchRect11/AnimatedSprite2D2".play("Talking")
		else:
			$"Camera2D/Dialogue Box/NinePatchRect11/AnimatedSprite2D2".play("Idle")
	if Input.is_action_just_pressed("Pause"):
		$"Camera2D/Pause Menu".show()
		$Timer.paused = true
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
						unhide_cells(neighbor)

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
	Globals.points *= Globals.point_mult
	Globals.total_points = Globals.points * (Globals.mult)
	$Camera2D/Points.text = "Points: " + str(Globals.points) + "
	" + "X" + "
	" + "Mult:" + str(Globals.mult) + "
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

func dialogue():
	$Timer.paused = true
	$Camera2D/Button.hide()
	$Camera2D/Button/AnimatedSprite2D.play("Idle")
	if dialogue_section == 1:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		dialogue_open = true
		$"Camera2D/Dialogue Box".visible = true
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Hello and welcome to Supa not
Evil Company! The boss has put
you in charge of getting his
money back from the mowls."
		dialogue_section += 1
		return
	if dialogue_section == 2:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "But first, you'll need to go
through employee training which
I'll take you through now."
		dialogue_section += 1
		return
	if dialogue_section == 3:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "The mowls planted flowers on
top of every patch of money and
have a mowl next to each patch
to guard it."
		dialogue_section += 1
		return
	if dialogue_section == 4:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Every flower is shaped like the
number of mowls around it, so
use that info to dermine which 
spots to dig and which to flag."
		dialogue_section += 1
		return
	if dialogue_section == 5:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Once you get to a field you'll only
have one minute to get all the
money you can before the mowls
find out whats happening."
		dialogue_section += 1
		return
	if dialogue_section == 6:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Some mowls will realize you're 
there and will destroy your flag
and replace that patch with even 
tuffer soil thats  harder to flag."
		dialogue_section += 1
		return
	if dialogue_section == 7:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "You'll only be able to take a
portion of the money you find
for buisness expenses but the
rest goes to the boss."
		dialogue_section += 1
		return
	if dialogue_section == 8:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Alright, now get to work and get
as much money as you can!"
		dialogue_section += 1
		return
	if dialogue_section == 9:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		dialogue_section = 1
		dialogue_open = false
		$Camera2D/Button.show()
		$Timer.paused = false
		$"Camera2D/Dialogue Box".visible = false
		$Camera2D/Panel.hide()

func game_over_dialogue():
	$Timer.paused = true
	$Camera2D/Button.hide()
	$Camera2D/Button/AnimatedSprite2D.play("Idle")
	if dialogue_section == 1:
		dialogue_open = true
		$"Camera2D/Dialogue Box".visible = true
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Uh oh! Looks like you dug up a
mowl! Normally, when you dig up
a mowl you'll lose all your money
and have to leave the field."
		dialogue_section += 1
		return
	if dialogue_section == 2:
		dialogue_open = true
		$"Camera2D/Dialogue Box".visible = true
		$"Camera2D/Dialogue Box/NinePatchRect/Label".text = "Try not to dig up anyone or else
we have a lot more paperwork
to deal with and you have a lot
more scrapes to heal."
		dialogue_section += 1
		return
	if dialogue_section == 3:
		$"Camera2D/Dialogue Box/NinePatchRect/Label".visible_characters = 0
		dialogue_section = 1
		dialogue_open = false
		$Camera2D/Button.show()
		$Timer.paused = false
		$"Camera2D/Dialogue Box".visible = false

func _on_dialogue_button_pressed() -> void:
	dialogue()
