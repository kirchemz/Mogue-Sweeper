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
		"rarity" : 1,
		"description" : "Automatically chords whenevery you flag a cell",
		"type" : "MOWL"
	},
	"mowl_time" : {
		"name" : "Mowl Time",
		"price" : 100,
		"time" : 10,
		"img" : preload("res://Sprites/Time Bonus.png"),
		"rarity" : 100,
		"description" : "Adds 10 seconds to the clock at the start",
		"type" : "MOWL"
	},
	"slow_mowl" : {
		"name" : "SLow Mowl",
		"price" : 100,
		"img" : preload("res://Sprites/Snail.png"),
		"rarity" : 100,
		"description" : "Makes EVERYTHING go half as fast for 5 seconds",
		"type" : "MOWL"
	},
	"fast_mowl" : {
		"name" : "Fast Mowl",
		"price" : 100,
		"img" : preload("res://Sprites/Fast Snail.png"),
		"rarity" : 100,
		"description" : "Makes EVERYTHING go twice as fast for 5 seconds",
		"type" : "MOWL"
	},
	"mowl_flags" : {
		"name" : "Mowl Flags",
		"price" : 100,
		"img" : preload("res://Sprites/Flag Generator.png"),
		"rarity" : 100,
		"description" : "Every 2 you get you get a blue flag, every three a yellow flag, every four a violet flag, every five a green flag, and every six a black flag",
		"type" : "MOWL"
	},
	"the_mowl_the_merrier" : {
		"name" : "The Mowl the Merrier",
		"price" : 100,
		"img" : preload("res://Sprites/Number Upgrader.png"),
		"rarity" : 100,
		"description" : "Every 100 ones, 80 twos, 10 threes, 5 fours, or 1 five through 8 you get an upgrade for that number",
		"type" : "MOWL"
	},
	"owl" : {
		"name" : "Owl",
		"price" : 100,
		"img" : preload("res://Sprites/Mine Scanner.png"),
		"rarity" : 30,
		"description" : "Reveals every cell within a 5 by 5 radius of where you put it. Press space or drag to place",
		"type" : "MOWL"
	},
	"greedy_mowl" : {
		"name" : "Greedy Mowl",
		"price" : 100,
		"img" : preload("res://Sprites/Double Trouble.png"),
		"rarity" : 100,
		"description" : "Retriggers twos",
		"type" : "MOWL"
	},
	"mowl_cascade" : {
		"name" : "Mowl Cascade",
		"price" : 100,
		"img" : preload("res://Sprites/Ability Base.png"),
		"rarity" : 30,
		"description" : "For every 4 cells revealed by the cascade earn 1 supa money",
		"type" : "MOWL"
	},
	"supa_flags" : {
		"name" : "Supa Flags",
		"price" : 100,
		"img" : preload("res://Sprites/Ability Base.png"),
		"rarity" : 30,
		"description" : "Destroys all other abilities and gives 1X mult for every flag placed other then blue and red. Given to you by Supa Evil Man",
		"type" : "SUPA"
	},
	"mowl_flags_again" : {
		"name" : "Mowl Flags, Again",
		"price" : 100,
		"img" : preload("res://Sprites/Flag Retriggers.png"),
		"rarity" : 1,
		"description" : "Retriggers all flags",
		"type" : "MOWL"
	},
	"even_pi" : {
		"name" : "Even Pi",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 100,
		"description" : "Every even number gets 3.14 times their points",
		"type" : "BAKERY"
	},
	"one_mowl" : {
		"name" : "One Mowl",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 10,
		"description" : "Every number acts like the number 1 greater than what it is currently acting as",
		"type" : "MOWL"
	},
	"double_trouble" : {
		"name" : "Double Trouble",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 100,
		"description" : "Every number gets a 1 in 8 chance to get double points. Chance multiplies by the number.",
		"type" : "MOWL"
	},
	"low_scorer" : {
		"name" : "Low Scorer",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 10,
		"description" : "If the only numbers that scored are twos and below get 2X mult.",
		"type" : "MOWL"
	},
	"high_scorer" : {
		"name" : "High Scorer",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 30,
		"description" : "If the only numbers that scored are threes and above, get 4X total score.",
		"type" : "MOWL"
	},
	"first_try" : {
		"name" : "First Try",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 30,
		"description" : "If the fist click is a cascade earn 100 supa money.",
		"type" : "MOWL"
	},
	"active_bomb" : {
		"name" : "Active Bomb",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 30,
		"description" : "Gives 5X mult but after every round it has a 1 in 5 chance to self-destruct and destroy the two abilities to its sides.",
		"type" : "MOWL"
	},
	"double_odds" : {
		"name" : "Double Odds",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 30,
		"description" : "All probabilities are doubled.",
		"type" : "MOWL"
	},
	"halved_odds" : {
		"name" : "Halved Odds",
		"price" : 100,
		"img" : preload("res://Sprites/Even Numbers.png"),
		"rarity" : 30,
		"description" : "All probabilities are Halved.",
		"type" : "MOWL"
	},
	"threes" : {
		"name" : "Threes",
		"price" : 100,
		"img" : preload("res://Sprites/Threes.png"),
		"rarity" : 1,
		"description" : "All threes give 2X mult.",
		"type" : "MOWL"
	},
	"one_two_three_four_five" : {
		"name" : "One Two Three Four Five",
		"price" : 100,
		"img" : preload("res://Sprites/Threes.png"),
		"rarity" : 10,
		"description" : "Gives 4X mult if there was a 1, 2, 3, 4, and 5 all scored.",
		"type" : "MOWL"
	},
	"mowl_abilities" : {
		"name" : "Mowl Abilities",
		"price" : 100,
		"img" : preload("res://Sprites/Threes.png"),
		"rarity" : 1,
		"description" : "Every mowl ability gives 1.5X mult. Unlocked by Mista Mowl for helping him get his son back",
		"type" : "MOWL"
	}
}

var empty_ability_one : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability One"
}
var empty_ability_two : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Two"
}
var empty_ability_three : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Three"
}
var empty_ability_four : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Four"
}
var empty_ability_five : Dictionary = {
	"img" : preload("res://Sprites/Ability Base.png"),
	"name" : "Ability Five"
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
var auto_chord : bool = false
var auto_chord_active : bool = false
var mowl_time : bool = false
var mowl_flags : bool = false
var the_mowl_the_marrier : bool = false
var ones_cleared : int = 0
var twos_cleared : int = 0
var threes_cleared : int = 0
var fours_cleared : int = 0
var fives_cleared : int = 0
var sixes_cleared : int = 0
var sevens_cleared : int = 0
var eights_cleared : int = 0
var nines_cleared : int = 0
var owl : bool = false
var owl_level : int = 1
var mine_lure : bool = false
var greedy_mowl : bool = false
var safe_start : bool = false
var mowl_cascade : bool = false
var casecade_count : int = 0
var mowl_flags_again : bool = false
var supa_flags : bool = false
var special_flag_count : int = 0
var even_pi : bool = false
var one_mowl : bool = false
var high_scorer : bool = false
var low_scorer : bool = false
var numbers_used : Array = []
var first_try : bool = false
var first_click : bool = true
var active_bomb : bool = false
var slow_mowl : bool = false
var fast_mowl : bool = false
var double_odds : bool = false
var halved_odds : bool = false
var threes : bool = false
var three_mult : int = 1
var one_two_three_four_five : bool = false
var mowl_abilities : bool = false
var set_abilities : bool = false
var ability1_set : bool = false
var ability2_set : bool = false
var ability3_set : bool = false
var ability4_set : bool = false
var ability5_set : bool = false

func _ready() -> void:
	for ability in ability_stock.values():
		ability_options.append(ability)

func _process(delta: float) -> void:
	if ability_stock.auto_chord in current_abilities:
		auto_chord = true
	if ability_stock.auto_chord in current_abilities:
		mowl_time = true
	if ability_stock.auto_chord in current_abilities:
		slow_mowl = true
	if ability_stock.auto_chord in current_abilities:
		fast_mowl = true
	if ability_stock.auto_chord in current_abilities:
		the_mowl_the_marrier = true
	if ability_stock.auto_chord in current_abilities:
		threes = true
	if ability_stock.auto_chord in current_abilities:
		one_two_three_four_five = true
	if ability_stock.auto_chord in current_abilities:
		mowl_flags = true
	if ability_stock.auto_chord in current_abilities:
		owl = true
	if ability_stock.auto_chord in current_abilities:
		greedy_mowl = true
	if ability_stock.auto_chord in current_abilities:
		mowl_abilities = true
	if ability_stock.auto_chord in current_abilities:
		supa_flags = true
	if ability_stock.auto_chord in current_abilities:
		mowl_flags_again = true
	if ability_stock.auto_chord in current_abilities:
		even_pi = true
	if ability_stock.auto_chord in current_abilities:
		low_scorer = true
	if ability_stock.auto_chord in current_abilities:
		high_scorer = true
	if ability_stock.auto_chord in current_abilities:
		first_try = true
	if ability_stock.auto_chord in current_abilities:
		mowl_cascade = true
	if ability_stock.auto_chord in current_abilities:
		double_odds = true
	if ability_stock.auto_chord in current_abilities:
		halved_odds = true
	if ability_stock.auto_chord in current_abilities:
		active_bomb = true
	if ability_stock.auto_chord in current_abilities:
		one_mowl = true
	if set_abilities:
		if not SaveLoad.data.ability1 == ability_one:
			if not ability1_set:
				ability1_set = true
				ability_one = SaveLoad.data.ability1
			if not ability2_set:
				ability2_set = true
				ability_two = SaveLoad.data.ability2
			if not ability3_set:
				ability3_set = true
				ability_three = SaveLoad.data.ability3
			if not ability4_set:
				ability4_set = true
				ability_four = SaveLoad.data.ability4
			if not ability5_set:
				ability5_set = true
				ability_five = SaveLoad.data.ability5
	if ability_one == ability_stock.supa_flags:
		current_abilities = [ability_stock.supa_flags]
		ability_two = empty_ability_two
		ability_three = empty_ability_three
		ability_four = empty_ability_four
		ability_five = empty_ability_five

func self_destruct(ability_number : int):
	if ability_number == 1:
		ability_one = empty_ability_one
		ability_two = empty_ability_two
	if ability_number == 2:
		ability_one = empty_ability_one
		ability_two = empty_ability_two
		ability_three = empty_ability_three
	if ability_number == 3:
		ability_two = empty_ability_two
		ability_three = empty_ability_three
		ability_four = empty_ability_four
	if ability_number == 4:
		ability_three = empty_ability_three
		ability_four = empty_ability_four
		ability_five = empty_ability_five
	if ability_number == 5:
		ability_four = empty_ability_four
		ability_five = empty_ability_five
