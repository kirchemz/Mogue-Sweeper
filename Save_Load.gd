extends Node

const file_path : String = "user://save_file.json"

var auto_save_timer : float = 0.0

var data : Dictionary = {
	"current_scene" : "res://World/level_selection.tscn",
	"volume" : 1.5,
	"music_volume" : 1.5,
	"sfx_volume" : 1.5,
	"quota" : 50,
	"currency" : 0,
	"current_quests" : [],
	"one_through_five" : false,
	"one_thousand_dollas" : false,
	"no_abilities" : false,
	"fifty_quota" : false,
	"current_level" : {},
	"ones_levels" : 1,
	"twos_levels" : 1,
	"threes_levels" : 1,
	"fours_levels" : 1,
	"fives_levels" : 1,
	"sixes_levels" : 1,
	"sevens_levels" : 1,
	"eights_levels" : 1,
	"nines_levels" : 1,
	"blue_flags" : 0,
	"violet_flags" : 0,
	"orange_flags" : 0,
	"green_flags" : 0,
	"pink_flags" : 0,
	"magenta_flags" : 0,
	"yellow_flags" : 0,
	"black_flags" : 0,
	"white_flags" : 0,
	"grey_flags" : 0,
	"brown_flags" : 0,
	"current_abilities" : [],
	"quest_options" : [],
	"auto_chord" : false,
	"mowl_time" : false,
	"mowl_flags" : false,
	"the_mowl_the_marrier" : false,
	"ones_cleared" : 0,
	"twos_cleared" : 0,
	"threes_cleared" : 0,
	"fours_cleared" : 0,
	"fives_cleared" : 0,
	"sixes_cleared" : 0,
	"sevens_cleared" : 0,
	"eights_cleared" : 0,
	"nines_cleared" : 0,
	"owl" : false,
	"owl_level" : 1,
	"greedy_mowl" : false,
	"safe_start" : false,
	"mowl_cascade" : false,
	"mowl_flags_again" : false,
	"supa_flags" : false,
	"even_pi" : false,
	"one_mowl" : false,
	"high_scorer" : false,
	"low_scorer" : false,
	"first_try" : false,
	"active_bomb" : false,
	"slow_mowl" : false,
	"fast_mowl" : false,
	"double_odds" : false,
	"halved_odds" : false,
	"threes" : false,
	"one_two_three_four_five" : false,
	"mowl_abilities" : false,
	"ability_options" : Abilities.ability_options,
	"ability1" : Abilities.empty_ability_one,
	"ability2" : Abilities.empty_ability_two,
	"ability3" : Abilities.empty_ability_three,
	"ability4" : Abilities.empty_ability_four,
	"ability5" : Abilities.empty_ability_five,
	"ability1_id" : "",
	"ability2_id" : "",
	"ability3_id" : "",
	"ability4_id" : "",
	"ability5_id" : "",
	"current_abilities_ids" : [],
	"ability_options_ids" : []
}

func clear() -> void:
	data = {
		"current_scene" : "res://World/level_selection.tscn",
		"volume" : 1.5,
		"music_volume" : 1.5,
		"sfx_volume" : 1.5,
		"quota" : 50,
		"currency" : 0,
		"current_quests" : [],
		"one_through_five" : false,
		"one_thousand_dollas" : false,
		"no_abilities" : false,
		"fifty_quota" : false,
		"current_level" : {},
		"ones_levels" : 1,
		"twos_levels" : 1,
		"threes_levels" : 1,
		"fours_levels" : 1,
		"fives_levels" : 1,
		"sixes_levels" : 1,
		"sevens_levels" : 1,
		"eights_levels" : 1,
		"nines_levels" : 1,
		"blue_flags" : 0,
		"violet_flags" : 0,
		"orange_flags" : 0,
		"green_flags" : 0,
		"pink_flags" : 0,
		"magenta_flags" : 0,
		"yellow_flags" : 0,
		"black_flags" : 0,
		"white_flags" : 0,
		"grey_flags" : 0,
		"brown_flags" : 0,
		"current_abilities" : [],
		"quest_options" : [],
		"auto_chord" : false,
		"mowl_time" : false,
		"mowl_flags" : false,
		"the_mowl_the_marrier" : false,
		"ones_cleared" : 0,
		"twos_cleared" : 0,
		"threes_cleared" : 0,
		"fours_cleared" : 0,
		"fives_cleared" : 0,
		"sixes_cleared" : 0,
		"sevens_cleared" : 0,
		"eights_cleared" : 0,
		"nines_cleared" : 0,
		"owl" : false,
		"owl_level" : 1,
		"greedy_mowl" : false,
		"safe_start" : false,
		"mowl_cascade" : false,
		"mowl_flags_again" : false,
		"supa_flags" : false,
		"even_pi" : false,
		"one_mowl" : false,
		"high_scorer" : false,
		"low_scorer" : false,
		"first_try" : false,
		"active_bomb" : false,
		"slow_mowl" : false,
		"fast_mowl" : false,
		"double_odds" : false,
		"halved_odds" : false,
		"threes" : false,
		"one_two_three_four_five" : false,
		"mowl_abilities" : false,
		"ability_options" : Abilities.ability_options,
		"ability1" : Abilities.empty_ability_one,
		"ability2" : Abilities.empty_ability_two,
		"ability3" : Abilities.empty_ability_three,
		"ability4" : Abilities.empty_ability_four,
		"ability5" : Abilities.empty_ability_five,
		"ability1_id" : "",
		"ability2_id" : "",
		"ability3_id" : "",
		"ability4_id" : "",
		"ability5_id" : "",
		"current_abilities_ids" : [],
		"ability_options_ids" : []
	}

	var file : FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file != null:
		file.store_var(data)
		file.close()

func _process(delta: float) -> void:
	auto_save_timer += delta
	if auto_save_timer >= 30:
		if is_instance_valid(get_tree().current_scene):
			if get_tree().current_scene.scene_file_path != "res://World/title_screen.tscn" and get_tree().current_scene.scene_file_path != "res://World/tutorial.tscn" and get_tree().current_scene.scene_file_path != "res://World/game_over.tscn" and get_tree().current_scene.scene_file_path != "res://World/level_selection.tscn":
				_save()

func _ability_to_id(ability: Dictionary) -> String:
	if ability.is_empty():
		return ""
	if ability.has("id"):
		return String(ability["id"])
	var ability_name: String = String(ability.get("name", ""))
	if ability_name == String(Abilities.empty_ability_one.get("name", "")):
		return "empty_ability_one"
	if ability_name == String(Abilities.empty_ability_two.get("name", "")):
		return "empty_ability_two"
	if ability_name == String(Abilities.empty_ability_three.get("name", "")):
		return "empty_ability_three"
	if ability_name == String(Abilities.empty_ability_four.get("name", "")):
		return "empty_ability_four"
	if ability_name == String(Abilities.empty_ability_five.get("name", "")):
		return "empty_ability_five"
	for key in Abilities.ability_stock.keys():
		if String(Abilities.ability_stock[key].get("name", "")) == ability_name:
			return key
	return ability_name

func _ability_from_id(id_value: String, fallback: Dictionary = {}) -> Dictionary:
	if id_value == "":
		return fallback if not fallback.is_empty() else Abilities.empty_ability_one
	match id_value:
		"empty_ability_one":
			return Abilities.empty_ability_one
		"empty_ability_two":
			return Abilities.empty_ability_two
		"empty_ability_three":
			return Abilities.empty_ability_three
		"empty_ability_four":
			return Abilities.empty_ability_four
		"empty_ability_five":
			return Abilities.empty_ability_five
	if id_value in Abilities.ability_stock:
		return Abilities.ability_stock[id_value]
	for ability in Abilities.ability_stock.values():
		if String(ability.get("name", "")) == id_value:
			return ability
	return fallback if not fallback.is_empty() else Abilities.empty_ability_one

func _abilities_from_ids(id_list: Array, fallback: Array = []) -> Array:
	var result: Array = []
	for entry in id_list:
		if entry is String:
			result.append(_ability_from_id(entry, Abilities.empty_ability_one))
		elif entry is Dictionary:
			result.append(_ability_from_id(_ability_to_id(entry), entry))
		else:
			result.append(entry)
	if result.is_empty() and not fallback.is_empty():
		return fallback
	return result

func _save():
	var file : FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	
	var master_bus = AudioServer.get_bus_index("Master")
	data.volume = AudioServer.get_bus_volume_linear(master_bus)
	var music_bus = AudioServer.get_bus_index("Music")
	data.music_volume = AudioServer.get_bus_volume_linear(music_bus)
	var sfx_bus = AudioServer.get_bus_index("SFX")
	data.sfx_volume = AudioServer.get_bus_volume_linear(sfx_bus)
	
	data.ones_levels = Globals.one_level
	data.twos_levels = Globals.two_level
	data.threes_levels = Globals.three_level
	data.fours_levels = Globals.four_level
	data.fives_levels = Globals.five_level
	data.sixes_levels = Globals.six_level
	data.sevens_levels = Globals.seven_level
	data.eights_levels = Globals.eight_level
	data.nines_levels = Globals.nine_level
	
	data.blue_flags = Globals.blue_flags
	data.violet_flags = Globals.violet_flags
	data.yellow_flags = Globals.yellow_flags
	data.orange_flags = Globals.orange_flags
	data.green_flags = Globals.green_flags
	data.pink_flags = Globals.pink_flags
	data.magenta_flags = Globals.magenta_flags
	data.white_flags = Globals.white_flags
	data.black_flags = Globals.black_flags
	data.grey_flags = Globals.grey_flags
	data.brown_flags = Globals.brown_flags
	
	data.auto_chord = Abilities.auto_chord
	data.mowl_time = Abilities.mowl_time
	data.mowl_flags = Abilities.mowl_flags
	data.the_mowl_the_marrier = Abilities.the_mowl_the_marrier
	data.ones_cleared = Abilities.ones_cleared
	data.twos_cleared = Abilities.twos_cleared
	data.threes_cleared = Abilities.threes_cleared
	data.fours_cleared = Abilities.fours_cleared
	data.fives_cleared = Abilities.fives_cleared
	data.sixes_cleared = Abilities.sixes_cleared
	data.sevens_cleared = Abilities.sevens_cleared
	data.eights_cleared = Abilities.eights_cleared
	data.nines_cleared = Abilities.nines_cleared
	data.owl = Abilities.owl
	data.owl_level = Abilities.owl_level
	data.greedy_mowl = Abilities.greedy_mowl
	data.safe_start = Abilities.safe_start
	data.mowl_cascade = Abilities.mowl_cascade
	data.mowl_flags_again = Abilities.mowl_flags_again
	data.supa_flags = Abilities.supa_flags
	data.even_pi = Abilities.even_pi
	data.one_mowl = Abilities.one_mowl
	data.low_scorer = Abilities.low_scorer
	data.high_scorer = Abilities.high_scorer
	data.first_try = Abilities.first_try
	data.active_bomb = Abilities.active_bomb
	data.slow_mowl = Abilities.slow_mowl
	data.fast_mowl = Abilities.fast_mowl
	data.double_odds = Abilities.double_odds
	data.halved_odds = Abilities.halved_odds
	data.threes = Abilities.threes
	data.mowl_abilities = Abilities.mowl_abilities
	data.one_two_three_four_five = Abilities.one_two_three_four_five
	
	data.ability1 = Abilities.ability_one
	data.ability2 = Abilities.ability_two
	data.ability3 = Abilities.ability_three
	data.ability4 = Abilities.ability_four
	data.ability5 = Abilities.ability_five
	data.ability1_id = _ability_to_id(Abilities.ability_one)
	data.ability2_id = _ability_to_id(Abilities.ability_two)
	data.ability3_id = _ability_to_id(Abilities.ability_three)
	data.ability4_id = _ability_to_id(Abilities.ability_four)
	data.ability5_id = _ability_to_id(Abilities.ability_five)
	data.current_abilities = Abilities.current_abilities
	data.current_abilities_ids = []
	for ability in Abilities.current_abilities:
		data.current_abilities_ids.append(_ability_to_id(ability))
	data.ability_options = Abilities.ability_options
	data.ability_options_ids = []
	for ability in Abilities.ability_options:
		data.ability_options_ids.append(_ability_to_id(ability))
	
	data.current_quests = Quests.current_quests
	data.quest_options = Quests.quest_options
	data.one_through_five = Quests.one_through_five
	data.one_thousand_dollas = Quests.one_thousand_dollas
	data.fifty_quota = Quests.fifty_quota
	
	data.current_level = Levels.chosen_level
	data.quota = Globals.level_requirement
	
	if is_instance_valid(get_tree().current_scene):
		if get_tree().current_scene.scene_file_path != "res://World/title_screen.tscn" and get_tree().current_scene.scene_file_path != "res://World/tutorial.tscn" and get_tree().current_scene.scene_file_path != "res://World/game_over.tscn" and get_tree().current_scene.scene_file_path != "res://World/level_selection.tscn":
			data.current_scene = get_tree().current_scene.scene_file_path
	file.store_var(data)
	file.close()

func _load():
	if FileAccess.file_exists(file_path):
		var file : FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var save_data : Dictionary = file.get_var()
		data = save_data
		if data.current_scene == "res://World/world.tscn":
			get_tree().change_scene_to_file("res://World/level_selection.tscn")
		elif data.current_scene == "res://World/tutorial.tscn":
			get_tree().change_scene_to_file("res://World/level_selection.tscn")
			Levels.tutorial = true
		else:
			get_tree().change_scene_to_file(data.current_scene)
			Levels.tutorial = false
			Levels.died = false
			Levels.death_level = {}

		var master_bus = AudioServer.get_bus_index("Master")
		var music_bus = AudioServer.get_bus_index("Music")
		var sfx_bus = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(master_bus, data.volume)
		AudioServer.set_bus_volume_db(music_bus, data.music_volume)
		AudioServer.set_bus_volume_db(sfx_bus, data.sfx_volume)
		
		Globals.one_level = data.ones_levels
		Globals.two_level = data.twos_levels
		Globals.three_level = data.threes_levels
		Globals.four_level = data.fours_levels
		Globals.five_level = data.fives_levels
		Globals.six_level = data.sixes_levels
		Globals.seven_level = data.sevens_levels
		Globals.eight_level = data.eights_levels
		Globals.nine_level = data.nines_levels
		
		Globals.blue_flags = data.blue_flags
		Globals.violet_flags = data.violet_flags
		Globals.yellow_flags = data.yellow_flags
		Globals.orange_flags = data.orange_flags
		Globals.green_flags = data.green_flags
		Globals.pink_flags = data.pink_flags
		Globals.magenta_flags = data.magenta_flags
		Globals.white_flags = data.white_flags
		Globals.black_flags = data.black_flags
		Globals.grey_flags = data.grey_flags
		Globals.brown_flags = data.brown_flags
		
		Abilities.auto_chord = data.auto_chord
		Abilities.mowl_time = data.mowl_time
		Abilities.mowl_flags = data.mowl_flags
		Abilities.the_mowl_the_marrier = data.the_mowl_the_marrier
		Abilities.ones_cleared = data.ones_cleared
		Abilities.twos_cleared = data.twos_cleared
		Abilities.threes_cleared = data.threes_cleared
		Abilities.fours_cleared = data.fours_cleared
		Abilities.fives_cleared = data.fives_cleared
		Abilities.sixes_cleared = data.sixes_cleared
		Abilities.sevens_cleared = data.sevens_cleared
		Abilities.eights_cleared = data.eights_cleared
		Abilities.nines_cleared = data.nines_cleared
		Abilities.owl = data.owl
		Abilities.owl_level = data.owl_level
		Abilities.greedy_mowl = data.greedy_mowl
		Abilities.safe_start = data.safe_start
		Abilities.mowl_cascade = data.mowl_cascade
		Abilities.mowl_flags_again = data.mowl_flags_again
		Abilities.supa_flags = data.supa_flags
		Abilities.even_pi = data.even_pi
		Abilities.one_mowl = data.one_mowl
		Abilities.low_scorer = data.low_scorer
		Abilities.high_scorer = data.high_scorer
		Abilities.first_try = data.first_try
		Abilities.active_bomb = data.active_bomb
		Abilities.slow_mowl = data.slow_mowl
		Abilities.fast_mowl = data.fast_mowl
		Abilities.double_odds = data.double_odds
		Abilities.halved_odds = data.halved_odds
		Abilities.threes = data.threes
		Abilities.mowl_abilities = data.mowl_abilities
		Abilities.one_two_three_four_five = data.one_two_three_four_five
		
		Abilities.ability_one = _ability_from_id(data.get("ability1_id", ""), data.get("ability1", Abilities.empty_ability_one))
		Abilities.ability_two = _ability_from_id(data.get("ability2_id", ""), data.get("ability2", Abilities.empty_ability_two))
		Abilities.ability_three = _ability_from_id(data.get("ability3_id", ""), data.get("ability3", Abilities.empty_ability_three))
		Abilities.ability_four = _ability_from_id(data.get("ability4_id", ""), data.get("ability4", Abilities.empty_ability_four))
		Abilities.ability_five = _ability_from_id(data.get("ability5_id", ""), data.get("ability5", Abilities.empty_ability_five))
		Abilities.current_abilities = _abilities_from_ids(data.get("current_abilities_ids", data.get("current_abilities", [])), data.get("current_abilities", []))
		Abilities.ability_options = _abilities_from_ids(data.get("ability_options_ids", data.get("ability_options", [])), data.get("ability_options", []))
		
		Quests.current_quests = data.current_quests
		Quests.quest_options = data.quest_options
		Quests.one_through_five = data.one_through_five
		Quests.one_thousand_dollas = data.one_thousand_dollas
		Quests.fifty_quota = data.fifty_quota
		
		Levels.chosen_level = data.current_level
		
		Globals.level_requirement = data.quota
		file.close()
