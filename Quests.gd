extends Node

var quest_options : Array = []
var quests : Dictionary = {
	"12345" : {
		"description" : "If you clear a 1, 2, 3, 4, and 5 in
one round I'll give you 500 Supa
Moneys! You'll have 3 rounds to
do it.",
		"reward" : 500,
		"time" : 3
	},
	"$1000" : {
		"description" : "If you make a total of 1000 Supa
Moneys in 3 rounds or less I'll
give you 1000 more.",
		"reward" : 500,
		"time" : 3
	},
	"no_abilities" : {
		"description" : "If you clear a round without
activating a single ability in 3
rounds, I will give you 500 Supa
Moneys!",
		"reward" : 500,
		"time" : 3
	},
	"50_quota" : {
		"description" : "If you clear a round 50 points
within the quota in 3 rounds, I'll
give you 500 Supa Moneys!",
		"reward" : 500,
		"time" : 3
	},
}

func _ready() -> void:
	for quest in quests.values():
		quest_options.append(quest)

func choose_quest():
	var chosen_quest : Dictionary
	chosen_quest = quest_options[randi() % quest_options.size()]
	
	return chosen_quest
