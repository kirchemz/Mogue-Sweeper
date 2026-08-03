extends Area2D

@onready var anim = $AnimatedSprite2D

var is_bomb : bool = false
var bombs_around : int = 0
var acting_number : int = 0
var acting_number_bonus : int = 0
var is_hidden : bool = true
var mouse_in : bool = false
var unhide_neighbors : bool = false
var can_be_bomb : bool = true
var flagged : bool = false
var flag_type : String = "Red"
var world
var flags_around : int = 0
var unflagged_bombs_around : bool = false
var mult : float = 0
var self_mult : float = 1
var point_bonus : int = 0
var bombs_around_set : bool = false
var scanned : bool = false
var got_points : bool = false
var dug_up : bool = false

# Funtion to set the cell as a bomb
func bomb():
	is_bomb = true

# Runs every frame
func _process(delta: float) -> void:
	# Mine Scanner
	if scanned:
		if is_bomb:
			flagged = true
			is_hidden = true
			if not dug_up:
				dig()
		else:
			flagged = false
			is_hidden = false
	
	# Tells the cell how many points it earns
	if bombs_around_set:
		acting_number = bombs_around + acting_number_bonus
		if acting_number == 1:
			point_bonus = Globals.ones_points.points
			mult = Globals.ones_points.mult
		if acting_number == 2:
			point_bonus = Globals.twos_points.points
			mult = Globals.twos_points.mult
		if acting_number == 3:
			point_bonus = Globals.threes_points.points
			mult = Globals.threes_points.mult
		if acting_number == 4:
			point_bonus = Globals.fours_points.points
			mult = Globals.fours_points.mult
		if acting_number == 5:
			point_bonus = Globals.fives_points.points
			mult = Globals.fives_points.mult
		if acting_number == 6:
			point_bonus = Globals.sixes_points.points
			mult = Globals.sixes_points.mult
		if acting_number == 7:
			point_bonus = Globals.sevens_points.points
			mult = Globals.sevens_points.mult
		if acting_number == 8:
			point_bonus = Globals.eights_points.points
			mult = Globals.eights_points.mult
		if acting_number == 9:
			point_bonus = Globals.nines_points.points
			mult = Globals.nines_points.mult
	# Sets the world
	world = get_parent().get_parent()
	
	# Tells the world scene if the mouse is over it or not
	if mouse_in:
		world.target_cell = self
	
	# Turns the cell into a basic cell with no special appearence if hidden
	if is_hidden:
		if flagged:
			if not dug_up:
				dig()
		elif is_bomb and not flagged:
			anim.play("Cell")
		else:
			if not dug_up:
				anim.play("Cell")
	
	# Gives the cell its image and number if unhidden
	if not is_hidden:
		if is_bomb:
			anim.play("Bomb")
		
		# Gives the cell the animation of the color filling in when unhidden
		if acting_number == 1 and not bombs_around == 0:
			var color_growth = create_tween()
			color_growth.tween_property($"1", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
		elif acting_number == 2:
			var color_growth = create_tween()
			color_growth.tween_property($"2", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
		elif acting_number == 3:
			var color_growth = create_tween()
			color_growth.tween_property($"3", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
		elif acting_number == 4:
			var color_growth = create_tween()
			color_growth.tween_property($"4", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
		elif acting_number == 5:
			var color_growth = create_tween()
			color_growth.tween_property($"5", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
		elif acting_number == 6:
			var color_growth = create_tween()
			color_growth.tween_property($"6", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
		if bombs_around == 0:
			if world.cells_set and not is_bomb:
				# Makes the cell shrink down and then destroys itself
				var destroy_tween = create_tween()
				destroy_tween.set_ease(Tween.EASE_IN)
				destroy_tween.tween_property(self, "scale", Vector2(0.01, 0.01), 0.75)
				destroy_tween.play()
				await destroy_tween.finished
				queue_free()

# Finds if the mouse is on this cell or not
func _on_mouse_entered() -> void:
	if is_instance_valid(world):
		if not world.mouse_over_menu:
			mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false

# Funtion to find out if there is a bomb around the cell that wasn't flagged - used when chording
func unflagged_bomb_around():
	var cell_instance = self
	cell_instance.is_hidden = false
	
	var xc = -1
	var yc = -1
	for y in range(world.map_height):
		for x in range(world.map_width):
			if world.map[x][y] == cell_instance:
				xc = x
				yc = y
	
	if xc == -1 or yc == -1:
		return
	
	for ay in range(-1, 2):
		for ax in range(-1, 2):
			var check_x = xc + ax
			var check_y = yc + ay
			if check_x >= 0 and check_x < world.map_width and check_y >= 0 and check_y < world.map_height:
				var neighbor = world.map[check_x][check_y]
				if is_instance_valid(neighbor):
					if neighbor.is_bomb and not neighbor.flagged:
						unflagged_bombs_around = true
	
	return unflagged_bombs_around

# Funtion to find out how many flags there are around the cell
func flag_around():
	var cell_instance = self
	if cell_instance.unhide_neighbors:
		return
	cell_instance.unhide_neighbors = true
	cell_instance.is_hidden = false
	
	var xc = -1
	var yc = -1
	for y in range(world.map_height):
		for x in range(world.map_width):
			if world.map[x][y] == cell_instance:
				xc = x
				yc = y
	
	if xc == -1 or yc == -1:
		return
	
	for ay in range(-1, 2):
		for ax in range(-1, 2):
			var check_x = xc + ax
			var check_y = yc + ay
			if check_x >= 0 and check_x < world.map_width and check_y >= 0 and check_y < world.map_height:
				var neighbor = world.map[check_x][check_y]
				if is_instance_valid(neighbor):
					if neighbor.flagged:
						flags_around += 1
	
	return flags_around

# Funtion to find out how many bombs around the cell were flagged - used in point count()
func flagged_bombs_around():
	var cell_instance = self
	scanned = false
	
	var xc = -1
	var yc = -1
	for y in range(world.map_height):
		for x in range(world.map_width):
			if world.map[x][y] == cell_instance:
				xc = x
				yc = y
	
	if xc == -1 or yc == -1:
		return
	
	for ay in range(-1, 2):
		for ax in range(-1, 2):
			var check_x = xc + ax
			var check_y = yc + ay
			if check_x >= 0 and check_x < world.map_width and check_y >= 0 and check_y < world.map_height:
				var neighbor = world.map[check_x][check_y]
				if is_instance_valid(neighbor):
					if neighbor.is_bomb and neighbor.flagged:
						if neighbor.flag_type == "Blue":
							self_mult += 1
						if neighbor.flag_type == "Purple":
							Globals.point_mult += 1
						if Abilities.mowl_flags_again:
							if neighbor.flag_type == "Blue":
								self_mult += 1
							if neighbor.flag_type == "Purple":
								Globals.point_mult += 1
						if Abilities.supa_flags:
							if not flag_type == "Red" and not flag_type == "Blue":
								Abilities.special_flag_count += 1
						if Abilities.even_pi:
							if acting_number == 2 or acting_number == 4 or acting_number == 6 or acting_number == 8:
								self_mult += point_bonus * 3.14
						if Abilities.threes:
							if acting_number == 3:
								Abilities.three_mult += 1
						Globals.points += (point_bonus * self_mult)
						Globals.mult += mult
						got_points = true
						if not acting_number in Abilities.numbers_used:
							Abilities.numbers_used.append(acting_number)
	if not unflagged_bomb_around() and flag_around() == bombs_around:
		if Abilities.mowl_flags:
			if acting_number == 2:
				Globals.blue_flags += 1
			if acting_number == 3:
				Globals.yellow_flags += 1
			if acting_number == 4:
				Globals.violet_flags += 1
			if acting_number == 5:
				Globals.green_flags += 1
			if acting_number >= 6:
				Globals.black_flags += 1
		if Abilities.the_mowl_the_marrier:
			if acting_number == 1:
				Abilities.ones_cleared += 1
				if Abilities.ones_cleared >= 100:
					Abilities.ones_cleared = 0
					Globals.upgrade_ones()
			if acting_number == 2:
				Abilities.twos_cleared += 1
				if Abilities.twos_cleared >= 80:
					Abilities.twos_cleared = 0
					Globals.upgrade_twos()
			if acting_number == 3:
				Abilities.threes_cleared += 1
				if Abilities.threes_cleared >= 10:
					Abilities.threes_cleared = 0
					Globals.upgrade_threes()
			if acting_number == 4:
				Abilities.fours_cleared += 1
				if Abilities.fours_cleared >= 5:
					Abilities.fours_cleared = 0
					Globals.upgrade_fours()
			if acting_number == 5:
				Abilities.fives_cleared += 1
				if Abilities.fives_cleared >= 2:
					Abilities.fives_cleared = 0
					Globals.upgrade_fives()
			if acting_number == 6:
				Abilities.sixes_cleared += 1
				if Abilities.sixes_cleared >= 1:
					Abilities.sixes_cleared = 0
					Globals.upgrade_sixes()
			if acting_number == 7:
				Abilities.sevens_cleared += 1
				if Abilities.sevens_cleared >= 1:
					Abilities.sevens_cleared = 0
					Globals.upgrade_sevens()
			if acting_number == 8:
				Abilities.eights_cleared += 1
				if Abilities.eights_cleared >= 1:
					Abilities.eights_cleared = 0
					Globals.upgrade_eights()
			if acting_number == 9:
				Abilities.nines_cleared += 1
				if Abilities.nines_cleared >= 1:
					Abilities.nines_cleared = 0
					Globals.upgrade_nines()

func white_out():
	var white_out_tween = create_tween()
	white_out_tween.tween_property($Sprite2D2, "modulate:a", 1, 0.4)
	white_out_tween.play()
	await white_out_tween.finished
	var white_out_reverse = create_tween()
	white_out_reverse.tween_property($Sprite2D2, "modulate:a", 0, 0.4)
	white_out_reverse.play()

func dig():
	dug_up = true
	if flag_type == "Red":
		anim.play("Red Dig")
	await anim.animation_finished
	if flag_type == "Red":
		anim.play("Red Idle")
