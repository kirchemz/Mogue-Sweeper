extends Node

const file_path : String = "user://save_file.json"

var auto_save_timer : float = 0.0

var data : Dictionary = {
	"current_scene" : "res://World/title_screen.tscn",
	"quota" : 50,
	"currency" : 0,
	"quests" : 0,
	"current_level" : 0,
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
	"ability_options" : Abilities.ability_options,
	"ability1" : Abilities.empty_ability_one,
	"ability2" : Abilities.empty_ability_two,
	"ability3" : Abilities.empty_ability_three,
	"ability4" : Abilities.empty_ability_four,
	"ability5" : Abilities.empty_ability_five
}

func _process(delta: float) -> void:
	auto_save_timer += delta
	if auto_save_timer >= 30:
		_save()

func _save():
	var file : FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	data.ability1 = Abilities.ability_one
	data.ability2 = Abilities.ability_two
	data.ability3 = Abilities.ability_three
	data.ability4 = Abilities.ability_four
	data.ability5 = Abilities.ability_five
	data.current_abilities = Abilities.current_abilities
	data.ability_options = Abilities.ability_options
	data.quota = Globals.level_requirement
	if is_instance_valid(get_tree().current_scene):
		if get_tree().current_scene.scene_file_path != "res://World/title_screen.tscn":
			data.current_scene = get_tree().current_scene.scene_file_path
	file.store_var(data)
	file.close()

func _load():
	if FileAccess.file_exists(file_path):
		var file : FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var save_data : Dictionary = file.get_var()
		data = save_data
		file.close()

func start():
	_load()
	if data.current_scene == "res://World/world.tscn":
		get_tree().change_scene_to_file("res://World/level_selection.tscn")
	else:
		get_tree().change_scene_to_file(data.current_scene)
	Abilities.ability_one = data.ability1
	Abilities.ability_one = data.ability2
	Abilities.ability_one = data.ability3
	Abilities.ability_one = data.ability4
	Abilities.ability_one = data.ability5
	Abilities.ability_options = data.ability_options
	Globals.level_requirement = data.quota
