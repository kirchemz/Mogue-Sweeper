extends Node

var money_mult : float = 1
var points_mult : float = 1
var flags_active : bool = true
var digging_debuff : bool = false
var chosen_level

var level_options : Array

var levels : Dictionary = {
	"money_db" : {
		"name" : "Money Debuff",
		"description" : "Currency gained at the end of the round is multiplied by 0.5"
	},
	"money_b" : {
		"name" : "Money Buff",
		"description" : "Currency gained at the end of the round is multiplied by 1.5"
	},
	"point_db" : {
		"name" : "Point Debuff",
		"description" : "Total Points gained at the end of the round are multiplied by 0.5"
	},
	"point_b" : {
		"name" : "Point Buff",
		"description" : "Total Points gained at the end of the round are multiplied by 1.5"
	},
	"flag_db" : {
		"name" : "Flag Debuff",
		"description" : "All flags other then the red flag are disabled"
	},
	"dig_db" : {
		"name" : "Digging Debuff",
		"description" : "Some spots aren't possible to dig up"
	}
}

func _ready() -> void:
	level_options = [levels.money_db, levels.money_b, levels.point_db, levels.point_b, levels.flag_db, levels.dig_db]

func choose_level():
	chosen_level = level_options[randi() % level_options.size()]

func _process(_delta: float) -> void:
	if not flags_active:
		Globals.activate_red()
	if chosen_level == levels.money_db:
		money_mult = 0.5
	elif chosen_level == levels.money_b:
		money_mult = 1.5
	else:
		money_mult = 1
	if chosen_level == levels.point_db:
		points_mult = 0.5
	elif chosen_level == levels.point_b:
		points_mult = 1.5
	else:
		points_mult = 1
	if chosen_level == levels.flag_db:
		flags_active = false
	else:
		flags_active = true
	if chosen_level == levels.dig_db:
		digging_debuff = true
	else:
		digging_debuff = false
