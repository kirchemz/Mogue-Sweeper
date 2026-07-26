extends Node

var points : float = 0.0
var point_mult : float = 1.0
var mult : float = 0.0
var total_points : float = 0.0
var level_requirement : int = 50
var currency : int = 0.0

var red_flag_active: bool = true
var blue_flags : int = false
var blue_flag_active : bool = false
var violet_flags : int = false
var violet_flag_active : bool = false
var orange_flags : int = false
var orange_flag_active : bool = false
var green_flags : int = false
var green_flag_active : bool = false
var black_flags : int = false
var black_flag_active : bool = false
var white_flags : int = false
var white_flag_active : bool = false
var grey_flags : int = false
var grey_flag_active : bool = false
var brown_flags : int = false
var brown_flag_active : bool = false
var yellow_flags : int = false
var yellow_flag_active : bool = false
var pink_flags : int = false
var pink_flag_active : bool = false
var magenta_flags : int = false
var magenta_flag_active : bool = false

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
