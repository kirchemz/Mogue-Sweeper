extends Node

var first_load : bool = true
var money_mult : float = 1.0
var points_mult : float = 1.0
var probability_mult : int = 10
var time_mult : float = 1.0
var flags_active : bool = true
var digging_debuff : bool = false
var chosen_level
var tutorial : bool = false
var death_level : Dictionary
var died : bool = false

var level_options : Array

var tutorial_level : Dictionary = {
	"name" : "Tutorial",
	"description" : "Employee Training",
	"plot_description" : "A training field for new employees to learn the basics of Mowling"
}

var levels : Dictionary = {
	"money_db" : {
		"name" : "Pay Cut",
		"description" : "Currency gained at the end of the round is multiplied by 0.5",
		"plot_description" : "The boss is letting you keep less of the money you find"
	},
	"money_b" : {
		"name" : "Pay Raise",
		"description" : "Currency gained at the end of the round is multiplied by 1.5",
		"plot_description" : "The boss is letting you keep more of the money you find"
	},
	"point_db" : {
		"name" : "Poor Field",
		"description" : "Total Points gained at the end of the round are multiplied by 0.5",
		"plot_description" : "The Mowls didn't bury much money here"
	},
	"point_b" : {
		"name" : "Wealthy Field",
		"description" : "Total Points gained at the end of the round are multiplied by 1.5",
		"plot_description" : "The Mowls burried a lot of money here turning the soil gold"
	},
	"flag_db" : {
		"name" : "Flag Debuff",
		"description" : "All flags other then the red flag are disabled",
		"plot_description" : ""
	},
	"dig_db" : {
		"name" : "Digging Debuff",
		"description" : "Some spots aren't possible to dig up",
		"plot_description" : ""
	},
	"time_db" : {
		"name" : "Time Debuff",
		"description" : "The clock's time at the start gets multiplied by 0.75",
		"plot_description" : "The Mowls here are a lot more focused"
	},
	"time_b" : {
		"name" : "Time Buff",
		"description" : "The clock's time at the start gets multiplied by 1.25",
		"plot_description" : "The Mowls here aren't as focused"
	},
	"double_odds" : {
		"name" : "Doubled Odds",
		"description" : "All probabilities are doubled",
		"plot_description" : ""
	},
	"halved_odds" : {
		"name" : "Halved Odds",
		"description" : "All probabilities are halved",
		"plot_description" : ""
	}
}

func _ready() -> void:
	for level in levels.values():
		level_options.append(level)

func choose_level():
	if died:
		chosen_level = death_level
	elif not tutorial:
		chosen_level = level_options[randi() % level_options.size()]
	else:
		chosen_level = tutorial_level

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
