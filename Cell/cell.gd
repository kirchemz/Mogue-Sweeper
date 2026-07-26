extends Area2D

@onready var bomb_tex = preload("res://Sprites/Bomb.png")
@onready var normal_tex = preload("res://Sprites/Cell.png")
@onready var flag_tex = preload("res://Sprites/Red Flag.png")

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
var mult : float = 1
var point_bonus : int = 0

func bomb():
	is_bomb = true
	$Sprite2D.texture = bomb_tex

func _process(delta: float) -> void:
	if is_instance_valid(bombs_around):
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
	world = get_parent().get_parent()
	if mouse_in:
		world.target_cell = self
	if is_hidden:
		if flagged:
			$Sprite2D.texture = flag_tex
		elif is_bomb and not flagged:
			$Sprite2D.texture = normal_tex
		else:
			$Sprite2D.texture = normal_tex
		if is_instance_valid($Label):
			$Label.visible = false
	if not is_hidden and not is_bomb:
		$Label.text = str(bombs_around)
	if is_bomb:
		if is_instance_valid($Label):
			$Label.queue_free()
	if not is_hidden:
		if is_instance_valid($Label):
			$Label.visible = true
		if is_bomb:
			$Sprite2D.texture = bomb_tex
		if bombs_around == 1:
			modulate = Color(0.0, 0.851, 0.157, 1.0)
		elif bombs_around == 2:
			modulate = Color(0.0, 0.553, 1.0, 1.0)
		elif bombs_around == 3:
			modulate = Color(0.839, 0.0, 0.0, 1.0)
		elif bombs_around == 4:
			modulate = Color(0.812, 0.0, 0.84, 1.0)
		elif bombs_around == 5:
			modulate = Color(0.77, 0.84, 0.0, 1.0)
		elif bombs_around == 6:
			modulate = Color(0.84, 0.574, 0.0, 1.0)
		elif bombs_around == 0:
			if world.cells_set and not is_bomb:
				queue_free()


func _on_mouse_entered() -> void:
	if is_instance_valid(world):
		if not world.mouse_over_menu:
			mouse_in = true


func _on_mouse_exited() -> void:
	mouse_in = false

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
							mult += 1
						if neighbor.flag_type == "Purple":
							Globals.point_mult += 1
						Globals.points += (point_bonus * mult)
