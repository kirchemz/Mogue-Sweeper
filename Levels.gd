extends Node

var first_load : bool = true
var money_mult : float = 1.0
var points_mult : float = 1.0
var probability_mult : int = 10
var time_mult : float = 1.0
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
	},
	"time_db" : {
		"name" : "Time Debuff",
		"description" : "The clock's time at the start gets multiplied by 0.75"
	},
	"time_b" : {
		"name" : "Time Buff",
		"description" : "The clock's time at the start gets multiplied by 1.25"
	},
	"double_odds" : {
		"name" : "Doubled Odds",
		"description" : "All probabilities are doubled"
	},
	"halved_odds" : {
		"name" : "Halved Odds",
		"description" : "All probabilities are halved"
	}
}

func _ready() -> void:
	for level in levels.values():
		level_options.append(level)

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
	if chosen_level == levels.time_db:
		time_mult = 0.75
	elif chosen_level == levels.time_b:
		time_mult = 1.25
	else:
		time_mult = 1
	if chosen_level == levels.double_odds:
		probability_mult *= 2
	elif chosen_level == levels.halved_odds:
		probability_mult /= 2
	else:
		probability_mult = 10
