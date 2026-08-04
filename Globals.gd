extends Node

# Each numbers current level
var one_level : int = 1
var two_level : int = 1
var three_level : int = 1
var four_level : int = 1
var five_level : int = 1
var six_level : int = 1
var seven_level : int = 1
var eight_level : int = 1
var nine_level : int = 1

# Dictionaries to hold the amount of points each number earns
var ones_points : Dictionary = {
	"points" : 1,
	"mult" : 0
}
var twos_points : Dictionary = {
	"points" : 2,
	"mult" : 0
}
var threes_points : Dictionary = {
	"points" : 3,
	"mult" : 0
}
var fours_points : Dictionary = {
	"points" : 4,
	"mult" : 0
}
var fives_points : Dictionary = {
	"points" : 5,
	"mult" : 1
}
var sixes_points : Dictionary = {
	"points" : 6,
	"mult" : 3
}
var sevens_points : Dictionary = {
	"points" : 7,
	"mult" : 5
}
var eights_points : Dictionary = {
	"points" : 8,
	"mult" : 7
}
var nines_points : Dictionary = {
	"points" : 100,
	"mult" : 100
}

# General global variables
var points : float = 0.0
var point_mult : float = 1.0
var mult : float = 1.0
var mult_mult : float = 1.0
var total_points : float = 0.0
var level_requirement : int = 50
var currency : int = 500

# All flag variables
var red_flag_active: bool = true
var blue_flags : int = 1000
var blue_flag_active : bool = false
var violet_flags : int = 4
var violet_flag_active : bool = false
var orange_flags : int = 4
var orange_flag_active : bool = false
var green_flags : int = 4
var green_flag_active : bool = false
var black_flags : int = 4
var black_flag_active : bool = false
var white_flags : int = 4
var white_flag_active : bool = false
var grey_flags : int = 10000
var grey_flag_active : bool = false
var brown_flags : int = 4
var brown_flag_active : bool = false
var yellow_flags : int = 4
var yellow_flag_active : bool = false
var pink_flags : int = 4
var pink_flag_active : bool = false
var magenta_flags : int = 4
var magenta_flag_active : bool = false

# Funtions for activating one flag and disabling all others
func activate_red():
	red_flag_active = true
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_blue():
	red_flag_active = false
	blue_flag_active = true
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_violet():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = true
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_pink():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = true

func activate_green():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = true
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_yellow():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = true
	pink_flag_active = false

func activate_orange():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = true
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_magenta():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = true
	yellow_flag_active = false
	pink_flag_active = false

func activate_black():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = true
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_white():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = true
	grey_flag_active = false
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_grey():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = true
	brown_flag_active = false
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

func activate_brown():
	red_flag_active = false
	blue_flag_active = false
	violet_flag_active = false
	orange_flag_active = false
	green_flag_active = false
	black_flag_active = false
	white_flag_active = false
	grey_flag_active = false
	brown_flag_active = true
	magenta_flag_active = false
	yellow_flag_active = false
	pink_flag_active = false

# Funtions for upgrading numbers
func upgrade_ones():
	ones_points.points += 1 * one_level
	one_level += 1

func upgrade_twos():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_threes():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_fours():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_fives():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_sixes():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_sevens():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_eights():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1

func upgrade_nines():
	twos_points.points += 1 * two_level
	two_level += 1
	var two_level_float : float = two_level
	if two_level_float / 5 == round(two_level_float / 5):
		twos_points.mult += 1


func _process(delta: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
