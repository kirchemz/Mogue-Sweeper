extends Area2D

@onready var bomb_tex = preload("res://Sprites/Bomb.png")
@onready var normal_tex = preload("res://Sprites/Cell.png")
@onready var flag_tex = preload("res://Sprites/Red Flag.png")

var pressed : bool = false

var is_bomb : bool = false
var bombs_around : int = 0
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
var find_points : bool = false
var bombs_around_set : bool = false

# Funtion to set the cell as a bomb
func bomb():
	is_bomb = true
	$Sprite2D.texture = bomb_tex

# Runs every frame
func _process(delta: float) -> void:
	# Tells the cell how many points it earns
	if bombs_around_set:
		if not find_points:
			if bombs_around == 1:
				point_bonus += Globals.ones_points.points
				mult += Globals.ones_points.mult
			if bombs_around == 2:
				point_bonus += Globals.ones_points.points
				mult += Globals.twos_points.mult
			if bombs_around == 3:
				point_bonus += Globals.ones_points.points
				mult += Globals.threes_points.mult
			if bombs_around == 4:
				point_bonus += Globals.ones_points.points
				mult += Globals.fours_points.mult
			if bombs_around == 5:
				point_bonus += Globals.ones_points.points
				mult += Globals.fives_points.mult
			if bombs_around == 6:
				point_bonus += Globals.ones_points.points
				mult += Globals.sixes_points.mult
			if bombs_around == 7:
				point_bonus += Globals.ones_points.points
				mult += Globals.sevens_points.mult
			if bombs_around == 8:
				point_bonus += Globals.ones_points.points
				mult += Globals.eights_points.mult
			if bombs_around == 9:
				point_bonus += Globals.ones_points.points
				mult += Globals.nines_points.mult
			find_points = true
	# Sets the world
	world = get_parent().get_parent()
	
	# Tells the world scene if the mouse is over it or not
	if mouse_in:
		world.target_cell = self
	
	# Turns the cell into a basic cell with no special appearence if hidden
	if is_hidden:
		if flagged:
			$Sprite2D.texture = flag_tex
		elif is_bomb and not flagged:
			$Sprite2D.texture = normal_tex
		else:
			$Sprite2D.texture = normal_tex
		if is_instance_valid($Label):
			$Label.visible = false
	
	# Sets the number in the cell
	if not is_hidden and not is_bomb:
		if is_instance_valid($Label):
			$Label.text = str(bombs_around)
	
	# Deletes the number if the cell is a bomb
	if is_bomb:
		if is_instance_valid($Label):
			$Label.queue_free()
	
	# Gives the cell its image and number if unhidden
	if not is_hidden:
		if is_bomb:
			$Sprite2D.texture = bomb_tex
		
		# Gives the cell the animation of the color filling in when unhidden
		if bombs_around == 1:
			var color_growth = create_tween()
			color_growth.tween_property($"1", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
			await color_growth.finished
			$Label.visible = true
		elif bombs_around == 2:
			var color_growth = create_tween()
			color_growth.tween_property($"2", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
			await color_growth.finished
			$Label.visible = true
		elif bombs_around == 3:
			var color_growth = create_tween()
			color_growth.tween_property($"3", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
			await color_growth.finished
			$Label.visible = true
		elif bombs_around == 4:
			var color_growth = create_tween()
			color_growth.tween_property($"4", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
			await color_growth.finished
			$Label.visible = true
		elif bombs_around == 5:
			var color_growth = create_tween()
			color_growth.tween_property($"5", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
			await color_growth.finished
			$Label.visible = true
		elif bombs_around == 6:
			var color_growth = create_tween()
			color_growth.tween_property($"6", "scale", Vector2(1, 1), 0.5)
			color_growth.play()
			await color_growth.finished
			$Label.visible = true
		elif bombs_around == 0:
			if world.cells_set and not is_bomb:
				# Deletes the number if there aren't any bombs around
				if is_instance_valid($Label):
					$Label.queue_free()
				
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
						Globals.points += (point_bonus * self_mult)
						Globals.mult += mult


func _on_touch_screen_button_pressed() -> void:
	pressed = true


func _on_touch_screen_button_released() -> void:
	pressed = false
