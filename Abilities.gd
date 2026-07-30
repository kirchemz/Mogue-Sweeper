extends Node

# Holds all current abilities in an array for clean access
var current_abilities : Array = []
var ability_options : Array = []

# Finds all abilities available for purchase or packs
var ability_stock : Dictionary = {
	"auto_chord" : {
		"name" : "Auto Chord",
		"price" : 100,
		"img" : preload("res://Sprites/Auto Chord.png"),
		"rarity" : 20
	},
	"time_bonus" : {
		"name" : "Time Bonus",
		"price" : 100,
		"time" : 10,
		"img" : preload("res://Sprites/Time Bonus.png"),
		"rarity" : 20
	},
	"flag_generator" : {
		"name" : "Flag Generator",
		"price" : 100,
		"img" : preload("res://Sprites/Flag Generator.png"),
		"rarity" : 20
	},
	"number_upgrader" : {
		"name" : "Number Upgrader",
		"price" : 100,
		"img" : preload("res://Sprites/Number Upgrader.png"),
		"rarity" : 20
	},
	"mine_scanner" : {
		"name" : "Mine Scanner",
		"price" : 100,
		"img" : preload("res://Sprites/Mine Scanner.png"),
		"rarity" : 20
	}
}

# Holds all data about current abilities
var ability_one : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability One"
}
var ability_two : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Two"
}
var ability_three : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Three"
}
var ability_four : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Four"
}
var ability_five : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Five"
}

# All variables relating to abilites
var auto_chord : bool = true
var auto_chord_active : bool = false
var time_bonus : bool = true
var flag_generator : bool = true
var number_upgrader : bool = true
var ones_cleared : int = 0
var twos_cleared : int = 0
var threes_cleared : int = 0
var fours_cleared : int = 0
var fives_cleared : int = 0
var sixes_cleared : int = 0
var sevens_cleared : int = 0
var eights_cleared : int = 0
var nines_cleared : int = 0
var mine_scanner : bool = true
var mine_scanner_level : int = 100
var mine_lure : bool = false

func _ready() -> void:
	ability_one = ability_stock.mine_scanner
	ability_two = ability_stock.time_bonus
	ability_three = ability_stock.number_upgrader
	ability_four = ability_stock.flag_generator
	ability_five = ability_stock.auto_chord
	for ability in ability_stock.values():
		ability_options.append(ability)
