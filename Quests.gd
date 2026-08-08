extends Node

var derick_quest_given : bool = false
var daisy_quest_given : bool = false
var jimmy_quest_given : bool = false
var anckle_quest_given : bool = false

var quest_options : Array = []

var quests : Dictionary = {
	"one_through_five" : {
		"description" : "If you clear a 1, 2, 3, 4, and 5 in
one round I'll give you 500 Supa
Moneys! You'll have 3 rounds to
do it.",
		"quest_board_description" : "Clear a 1, 2, 3, 4, and 5 in one round.",
		"reward" : 1000,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
	"one_thousand_dollas" : {
		"description" : "If you make a total of 1000 Supa
Moneys in 3 rounds or less I'll
give you 500 more.",
		"quest_board_description" : "Make a total of 1000 Supa Moneys.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
	"fifty_quota" : {
		"description" : "If you clear a round 50 points
within the quota in 3 rounds, I'll
give you 500 Supa Moneys!",
		"quest_board_description" : "Clear a round 50 points within the quota.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
	"no_mult" : {
		"description" : "If you clear a round without
adding any mult in three rounds,
I'll give you 500 Supa Moneys.",
		"quest_board_description" : "Clear a round without adding any mult.",
		"reward" : 500,
		"giver" : "",
		"time" : 3,
		"completed" : false
	},
}

var one_through_five : bool = false
var one_thousand_dollas : bool = false
var fifty_quota : bool = false
var no_mult : bool = false
var current_quests : Array = []
var total_money : int = 0

func _ready() -> void:
	for quest in quests.values():
		quest_options.append(quest)

func _process(delta: float) -> void:
	if total_money >= 1000:
		total_money = 0
		Quests.current_quests[Quests.current_quests.find(Quests.quests.fifty_quota)].completed = true

func choose_quest():
	var chosen_quest : Dictionary
	chosen_quest = quest_options[randi() % quest_options.size()]
	
	return chosen_quest
