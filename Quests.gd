extends Node

var derick_quest_given : bool = false
var daisy_quest_given : bool = false
var jimmy_quest_given : bool = false

var quest_options : Array = []

var quests : Dictionary = {
	"one_through_five" : {
		"description" : "If you clear a 1, 2, 3, 4, and 5 in
one round I'll give you 500 Supa
Moneys! You'll have 3 rounds to
do it.",
		"quest_board_description" : "Clear a 1, 2, 3, 4, and 5 in one round.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
	"one_thousand_dollas" : {
		"description" : "If you make a total of 1000 Supa
Moneys in 3 rounds or less I'll
give you 1000 more.",
		"quest_board_description" : "Make a total of 1000 Supa Moneys.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
	"no_abilities" : {
		"description" : "If you clear a round without
activating a single ability in 3
rounds, I will give you 500 Supa
Moneys!",
		"quest_board_description" : "Clear a round without activating a single ability.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
	"50_quota" : {
		"description" : "If you clear a round 50 points
within the quota in 3 rounds, I'll
give you 500 Supa Moneys!",
		"quest_board_description" : "Clear a round 50 points within the quota.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
}

var current_quests : Array = [quests.one_through_five, quests.one_thousand_dollas]

func _ready() -> void:
	for quest in quests.values():
		quest_options.append(quest)

func choose_quest():
	var chosen_quest : Dictionary
	chosen_quest = quest_options[randi() % quest_options.size()]
	
	return chosen_quest
