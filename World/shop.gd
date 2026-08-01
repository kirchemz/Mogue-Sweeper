extends Node2D

var ability_one : Dictionary
var ability_two : Dictionary
var ability_three : Dictionary
var flag_one : Dictionary
var flag_two : Dictionary
var flag_three : Dictionary
var flag_options : Array
var rock_one : Dictionary
var rock_two : Dictionary
var rock_three : Dictionary
var rock_options : Array
var opening_pack : bool = false
var rock_pack_opened : bool = false
var rock_pack_option_chosen : bool = false
var extra_one : Dictionary
var extra_two : Dictionary
var extra_three : Dictionary
var extra_options : Array
var extra_pack_opened : bool = false
var extra_pack_option_chosen : bool = false

# All rocks available for packs
var rock_stock : Dictionary = {
	"granite" : {
		"name" : "Granite",
		"img" : preload("res://Sprites/Granite.png"),
		"rarity" : 30
	},
	"quartz" : {
		"name" : "Quartz",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 3000
	},
	"basalt" : {
		"name" : "Basalt",
		"img" : preload("res://Sprites/Basalt.png"),
		"rarity" : 20
	},
	"obsidian" : {
		"name" : "Obsidian",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 10
	},
	"fluorite" : {
		"name" : "Fluorite",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 10
	},
	"diamond" : {
		"name" : "Diamond",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 5
	},
	"emerald" : {
		"name" : "Emerald",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 5
	},
	"black_opal" : {
		"name" : "Black Opal",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 1
	},
	"red_diamond" : {
		"name" : "Red Diamond",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 1
	}
}

# All flags available for purchase and packs
var flag_stock : Dictionary = {
	"blue_flag" : {
		"name" : "Blue Flag",
		"price" : 10,
		"img" : preload("res://Sprites/Blue Flag.png"),
		"rarity" : 50
	},
	"violet_flag" : {
		"name" : "Violet Flag",
		"price" : 1000,
		"img" : preload("res://Sprites/Purple Flag.png"),
		"rarity" : 15
	},
	"orange_flag" : {
		"name" : "Orange Flag",
		"price" : 100,
		"img" : preload("res://Sprites/Orange Flag.png"),
		"rarity" : 1
	},
	"green_flag" : {
		"name" : "Green Flag",
		"price" : 1000,
		"img" : preload("res://Sprites/Green Flag.png"),
		"rarity" : 2
	},
	"yellow_flag" : {
		"name" : "Yellow Flag",
		"price" : 100,
		"img" : preload("res://Sprites/Yellow Flag.png"),
		"rarity" : 25
	},
	"pink_flag" : {
		"name" : "Pink Flag",
		"price" : 1000,
		"img" : preload("res://Sprites/Pink Flag.png"),
		"rarity" : 1
	},
	"magenta_flag" : {
		"name" : "Magenta Flag",
		"price" : 100,
		"img" : preload("res://Sprites/Magenta Flag.png"),
		"rarity" : 1
	},
	"black_flag" : {
		"name" : "Black Flag",
		"price" : 1000,
		"img" : preload("res://Sprites/Black Flag.png"),
		"rarity" : 1
	},
	"white_flag" : {
		"name" : "White Flag",
		"price" : 100,
		"img" : preload("res://Sprites/White Flag.png"),
		"rarity" : 1
	},
	"grey_flag" : {
		"name" : "Grey Flag",
		"price" : 1000,
		"img" : preload("res://Sprites/Grey Flag.png"),
		"rarity" : 1
	},
	"brown_flag" : {
		"name" : "Brown Flag",
		"price" : 100,
		"img" : preload("res://Sprites/Brown Flag.png"),
		"rarity" : 1
	}
}

# Runs once as soon as the scene is played
func _ready() -> void:
	# Sets the background color
	RenderingServer.set_default_clear_color(Color(0.475, 0.255, 0.0, 1.0))
	
	# Sets flag and ability options and rock and extra pack options
	flag_options = [flag_stock.blue_flag, flag_stock.violet_flag, flag_stock.yellow_flag, flag_stock.orange_flag, flag_stock.magenta_flag, flag_stock.pink_flag, flag_stock.black_flag, flag_stock.brown_flag, flag_stock.white_flag, flag_stock.grey_flag]
	extra_options = [flag_stock.blue_flag, flag_stock.violet_flag, flag_stock.yellow_flag, flag_stock.orange_flag, flag_stock.magenta_flag, flag_stock.pink_flag, flag_stock.black_flag, flag_stock.brown_flag, flag_stock.white_flag, flag_stock.grey_flag]
	rock_options = [rock_stock.granite, rock_stock.quartz, rock_stock.basalt, rock_stock.obsidian, rock_stock.fluorite, rock_stock.diamond, rock_stock.emerald, rock_stock.black_opal, rock_stock.red_diamond]
	
	# Picks what flags, abilities, and rocks that show up for purchase and in packs
	ability_one = choose_item(Abilities.ability_options)
	Abilities.ability_options.erase(ability_one)
	ability_two = choose_item(Abilities.ability_options)
	Abilities.ability_options.erase(ability_two)
	ability_three = choose_item(Abilities.ability_options)
	Abilities.ability_options.erase(ability_three)
	flag_one = choose_item(flag_options)
	flag_options.erase(flag_one)
	flag_two = choose_item(flag_options)
	flag_options.erase(flag_two)
	flag_three = choose_item(flag_options)
	flag_options.erase(flag_three)
	rock_one = choose_item(rock_options)
	rock_options.erase(rock_one)
	rock_two = choose_item(rock_options)
	rock_options.erase(rock_two)
	rock_three = choose_item(rock_options)
	rock_options.erase(rock_three)
	extra_one = choose_item(extra_options)
	extra_options.erase(extra_one)
	extra_two = choose_item(extra_options)
	extra_options.erase(extra_two)
	extra_three = choose_item(extra_options)
	extra_options.erase(extra_three)

func _process(delta: float) -> void:
	if rock_pack_option_chosen:
		var camera_drag = create_tween()
		camera_drag.set_ease(Tween.EASE_IN_OUT)
		camera_drag.set_trans(Tween.TRANS_BACK)
		camera_drag.tween_property($Camera2D, "position", Vector2(576, 324), 1)
		camera_drag.play()
		rock_pack_option_chosen = false
		$"Rock Pack".queue_free()
		await camera_drag.finished
		rock_pack_opened = true
	if extra_pack_option_chosen:
		var camera_drag = create_tween()
		camera_drag.set_ease(Tween.EASE_IN_OUT)
		camera_drag.set_trans(Tween.TRANS_BACK)
		camera_drag.tween_property($Camera2D, "position", Vector2(576, 324), 1)
		camera_drag.play()
		extra_pack_option_chosen = false
		$"Extra Pack".queue_free()
		await camera_drag.finished
		extra_pack_opened = true
	$"Ability 1".texture_normal = Abilities.ability_one.img
	$"Ability 1/Label".text = Abilities.ability_one.name
	$"Ability 1/Label".scale = $"Ability 1/Label".get_total_character_count() * (Vector2(0.002, 0.002) / ($"Ability 1/Label".get_total_character_count() / 9))
	$"Ability 2".texture_normal = Abilities.ability_two.img
	$"Ability 2/Label".text = Abilities.ability_two.name
	$"Ability 3".texture_normal = Abilities.ability_three.img
	$"Ability 3/Label".text = Abilities.ability_three.name
	$"Ability 4".texture_normal = Abilities.ability_four.img
	$"Ability 4/Label".text = Abilities.ability_four.name
	$"Ability 5".texture_normal = Abilities.ability_five.img
	$"Ability 5/Label".text = Abilities.ability_five.name
	$NinePatchRect2/Label.text = "$"  + str(Globals.currency)
	if ability_one == Abilities.ability_stock.auto_chord:
		Abilities.auto_chord = true
	if is_instance_valid($"Ability One"):
		$"Ability One".texture_normal = ability_one.img
		$"Ability One/Label".text = ability_one.name + ": " + str(ability_one.price)
	if is_instance_valid($"Ability Two"):
		$"Ability Two".texture_normal = ability_two.img
		$"Ability Two/Label".text = ability_two.name + ": " + str(ability_two.price)
	if is_instance_valid($"Ability Three"):
		$"Ability Three".texture_normal = ability_three.img
		$"Ability Three/Label".text = ability_three.name + ": " + str(ability_three.price)
	if is_instance_valid($"Flag One"):
		$"Flag One".texture_normal = flag_one.img
		$"Flag One/Label".text = flag_one.name + ": " + str(flag_one.price)
	if is_instance_valid($"Flag Two"):
		$"Flag Two".texture_normal = flag_two.img
		$"Flag Two/Label".text = flag_two.name + ": " + str(flag_two.price)
	if is_instance_valid($"Flag Three"):
		$"Flag Three".texture_normal = flag_three.img
		$"Flag Three/Label".text = flag_three.name + ": " + str(flag_three.price)
	$"Rock One".texture_normal = rock_one.img
	$"Rock One/Label".text = rock_one.name
	$"Rock Two".texture_normal = rock_two.img
	$"Rock Two/Label".text = rock_two.name
	$"Rock Three".texture_normal = rock_three.img
	$"Rock Three/Label".text = rock_three.name
	$"Extra One".texture_normal = extra_one.img
	$"Extra One/Label".text = extra_one.name
	$"Extra Two".texture_normal = extra_two.img
	$"Extra Two/Label".text = extra_two.name
	$"Extra Three".texture_normal = extra_three.img
	$"Extra Three/Label".text = extra_three.name

func _on_texture_button_pressed() -> void:
	Globals.level_requirement *= 2
	get_tree().change_scene_to_file("res://World/level_selection.tscn")

func _on_ability_one_pressed() -> void:
	if Globals.currency >= ability_one.price:
		var have_space : bool = true
		if Abilities.current_abilities.size() == 0:
			Abilities.ability_one = ability_one
		elif Abilities.current_abilities.size() == 1:
			Abilities.ability_two = ability_one
		elif Abilities.current_abilities.size() == 2:
			Abilities.ability_three = ability_one
		elif Abilities.current_abilities.size() == 3:
			Abilities.ability_four = ability_one
		elif Abilities.current_abilities.size() == 4:
			Abilities.ability_five = ability_one
		else:
			have_space = false
		if have_space:
			Globals.currency -= ability_one.price
			if ability_one == Abilities.ability_stock.auto_chord:
				Abilities.auto_chord = true
			if ability_one == Abilities.ability_stock.mowl_time:
				Abilities.mowl_time = true
			if ability_one == Abilities.ability_stock.mowl_flags:
				Abilities.mowl_flags = true
			if ability_one == Abilities.ability_stock.the_mowl_the_merrier:
				Abilities.the_mowl_the_marrier = true
			if ability_one == Abilities.ability_stock.lawn_mowler:
				Abilities.lawn_mowler = true
			if ability_one == Abilities.ability_stock.greedy_mowl:
				Abilities.greedy_mowl = true
			if ability_one == Abilities.ability_stock.mowl_cascade:
				Abilities.mowl_cascade = true
			Abilities.current_abilities.append(ability_one)
			$"Ability One".queue_free()

func _on_ability_two_pressed() -> void:
	if Globals.currency >= ability_two.price:
		var have_space : bool = true
		if Abilities.current_abilities.size() == 0:
			Abilities.ability_one = ability_two
		elif Abilities.current_abilities.size() == 1:
			Abilities.ability_two = ability_two
		elif Abilities.current_abilities.size() == 2:
			Abilities.ability_three = ability_two
		elif Abilities.current_abilities.size() == 3:
			Abilities.ability_four = ability_two
		elif Abilities.current_abilities.size() == 4:
			Abilities.ability_five = ability_two
		else:
			have_space = false
		if have_space:
			Globals.currency -= ability_two.price
			if ability_two == Abilities.ability_stock.auto_chord:
				Abilities.auto_chord = true
			if ability_two == Abilities.ability_stock.mowl_time:
				Abilities.mowl_time = true
			if ability_two == Abilities.ability_stock.mowl_flags:
				Abilities.mowl_flags = true
			if ability_two == Abilities.ability_stock.the_mowl_the_merrier:
				Abilities.the_mowl_the_marrier = true
			if ability_two == Abilities.ability_stock.lawn_mowler:
				Abilities.lawn_mowler = true
			if ability_two == Abilities.ability_stock.greedy_mowl:
				Abilities.greedy_mowl = true
			if ability_two == Abilities.ability_stock.mowl_cascade:
				Abilities.mowl_cascade = true
			Abilities.current_abilities.append(ability_two)
			$"Ability Two".queue_free()

func _on_ability_three_pressed() -> void:
	if Globals.currency >= ability_three.price:
		var have_space : bool = true
		if Abilities.current_abilities.size() == 0:
			Abilities.ability_one = ability_three
		elif Abilities.current_abilities.size() == 1:
			Abilities.ability_two = ability_three
		elif Abilities.current_abilities.size() == 2:
			Abilities.ability_three = ability_three
		elif Abilities.current_abilities.size() == 3:
			Abilities.ability_four = ability_three
		elif Abilities.current_abilities.size() == 4:
			Abilities.ability_five = ability_three
		else:
			have_space = false
		if have_space:
			Globals.currency -= ability_three.price
			if ability_three == Abilities.ability_stock.auto_chord:
				Abilities.auto_chord = true
			if ability_three == Abilities.ability_stock.mowl_time:
				Abilities.mowl_time = true
			if ability_three == Abilities.ability_stock.mowl_flags:
				Abilities.mowl_flags = true
			if ability_three == Abilities.ability_stock.the_mowl_the_merrier:
				Abilities.the_mowl_the_marrier = true
			if ability_three == Abilities.ability_stock.lawn_mowler:
				Abilities.lawn_mowler = true
			if ability_three == Abilities.ability_stock.greedy_mowl:
				Abilities.greedy_mowl = true
			if ability_three == Abilities.ability_stock.mowl_cascade:
				Abilities.mowl_cascade = true
			Abilities.current_abilities.append(ability_three)
			$"Ability Three".queue_free()

func _on_flag_one_pressed() -> void:
	if Globals.currency >= flag_one.price:
		Globals.currency -= flag_one.price
		if flag_one == flag_stock.blue_flag:
			Globals.blue_flags += 1
		if flag_one == flag_stock.violet_flag:
			Globals.violet_flags += 1
		if flag_one == flag_stock.green_flag:
			Globals.green_flags += 1
		if flag_one == flag_stock.orange_flag:
			Globals.orange_flags += 1
		if flag_one == flag_stock.yellow_flag:
			Globals.yellow_flags += 1
		if flag_one == flag_stock.magenta_flag:
			Globals.magenta_flags += 1
		if flag_one == flag_stock.pink_flag:
			Globals.pink_flags += 1
		if flag_one == flag_stock.black_flag:
			Globals.black_flags += 1
		if flag_one == flag_stock.white_flag:
			Globals.white_flags += 1
		if flag_one == flag_stock.grey_flag:
			Globals.grey_flags += 1
		if flag_one == flag_stock.brown_flag:
			Globals.brown_flags += 1

func _on_flag_two_pressed() -> void:
	if Globals.currency >= flag_two.price:
		Globals.currency -= flag_two.price
		if flag_two == flag_stock.blue_flag:
			Globals.blue_flags += 1
		if flag_two == flag_stock.violet_flag:
			Globals.violet_flags += 1
		if flag_two == flag_stock.green_flag:
			Globals.green_flags += 1
		if flag_two == flag_stock.orange_flag:
			Globals.orange_flags += 1
		if flag_two == flag_stock.yellow_flag:
			Globals.yellow_flags += 1
		if flag_two == flag_stock.magenta_flag:
			Globals.magenta_flags += 1
		if flag_two == flag_stock.pink_flag:
			Globals.pink_flags += 1
		if flag_two == flag_stock.black_flag:
			Globals.black_flags += 1
		if flag_two == flag_stock.white_flag:
			Globals.white_flags += 1
		if flag_two == flag_stock.grey_flag:
			Globals.grey_flags += 1
		if flag_two == flag_stock.brown_flag:
			Globals.brown_flags += 1

func _on_flag_three_pressed() -> void:
	if Globals.currency >= flag_three.price:
		Globals.currency -= flag_three.price
		if flag_three == flag_stock.blue_flag:
			Globals.blue_flags += 1
		if flag_three == flag_stock.violet_flag:
			Globals.violet_flags += 1
		if flag_three == flag_stock.green_flag:
			Globals.green_flags += 1
		if flag_three == flag_stock.orange_flag:
			Globals.orange_flags += 1
		if flag_three == flag_stock.yellow_flag:
			Globals.yellow_flags += 1
		if flag_three == flag_stock.magenta_flag:
			Globals.magenta_flags += 1
		if flag_three == flag_stock.pink_flag:
			Globals.pink_flags += 1
		if flag_three == flag_stock.black_flag:
			Globals.black_flags += 1
		if flag_three == flag_stock.white_flag:
			Globals.white_flags += 1
		if flag_three == flag_stock.grey_flag:
			Globals.grey_flags += 1
		if flag_three == flag_stock.brown_flag:
			Globals.brown_flags += 1

func choose_item(pack: Array):
	if pack.is_empty():
		return null

	var total_weight := 0
	for item in pack:
		total_weight += item.rarity

	var chosen_item := randf() * total_weight

	for item in pack:
		if chosen_item < item.rarity:
			return item
		chosen_item -= item.rarity

	return pack[pack.size() - 1]


func _on_texture_button_2_pressed() -> void:
	if Globals.currency >= 500:
		opening_pack = true
		$"Rock Pack".texture_normal = preload("res://Sprites/Rock Pack Opened.png")
		$"Rock Pack".offset_transform_position.x = -48
		$"Rock Pack"/Button.offset_transform_position.x = 48
		await get_tree().create_timer(0.25).timeout
		var camera_drag = create_tween()
		camera_drag.set_ease(Tween.EASE_IN_OUT)
		camera_drag.set_trans(Tween.TRANS_BACK)
		camera_drag.tween_property($Camera2D, "position", Vector2(1728, 324), 1)
		camera_drag.play()
		Globals.currency -= 500

func _on_button_pressed() -> void:
	opening_pack = true
	$"Rock Pack".texture_normal = preload("res://Sprites/Rock Pack Opened.png")
	$"Rock Pack".offset_transform_position.x = -48
	$"Rock Pack"/Button.offset_transform_position.x = 48
	await get_tree().create_timer(0.25).timeout
	var camera_drag = create_tween()
	camera_drag.set_ease(Tween.EASE_IN_OUT)
	camera_drag.set_trans(Tween.TRANS_BACK)
	camera_drag.tween_property($Camera2D, "position", Vector2(1728, 324), 1)
	camera_drag.play()

func _on_rock_one_pressed() -> void:
	if rock_one == rock_stock.granite:
		Globals.upgrade_ones()
	if rock_one == rock_stock.quartz:
		Globals.upgrade_twos()
	if rock_one == rock_stock.basalt:
		Globals.upgrade_threes()
	if rock_one == rock_stock.obsidian:
		Globals.upgrade_fours()
	if rock_one == rock_stock.fluorite:
		Globals.upgrade_fives()
	if rock_one == rock_stock.diamond:
		Globals.upgrade_sixes()
	if rock_one == rock_stock.emerald:
		Globals.upgrade_sevens()
	if rock_one == rock_stock.black_opal:
		Globals.upgrade_eights()
	if rock_one == rock_stock.red_diamond:
		Globals.upgrade_nines()
	rock_pack_option_chosen = true

func _on_rock_two_pressed() -> void:
	if rock_two == rock_stock.granite:
		Globals.upgrade_ones()
	if rock_two == rock_stock.quartz:
		Globals.upgrade_twos()
	if rock_two == rock_stock.basalt:
		Globals.upgrade_threes()
	if rock_two == rock_stock.obsidian:
		Globals.upgrade_fours()
	if rock_two == rock_stock.fluorite:
		Globals.upgrade_fives()
	if rock_two == rock_stock.diamond:
		Globals.upgrade_sixes()
	if rock_two == rock_stock.emerald:
		Globals.upgrade_sevens()
	if rock_two == rock_stock.black_opal:
		Globals.upgrade_eights()
	if rock_two == rock_stock.red_diamond:
		Globals.upgrade_nines()
	rock_pack_option_chosen = true

func _on_rock_three_pressed() -> void:
	if rock_three == rock_stock.granite:
		Globals.upgrade_ones()
	if rock_three == rock_stock.quartz:
		Globals.upgrade_twos()
	if rock_three == rock_stock.basalt:
		Globals.upgrade_threes()
	if rock_three == rock_stock.obsidian:
		Globals.upgrade_fours()
	if rock_three == rock_stock.fluorite:
		Globals.upgrade_fives()
	if rock_three == rock_stock.diamond:
		Globals.upgrade_sixes()
	if rock_three == rock_stock.emerald:
		Globals.upgrade_sevens()
	if rock_three == rock_stock.black_opal:
		Globals.upgrade_eights()
	if rock_three == rock_stock.red_diamond:
		Globals.upgrade_nines()
	rock_pack_option_chosen = true

func _on_extra_pack_pressed() -> void:
	if Globals.currency >= 500:
		opening_pack = true
		$"Extra Pack".texture_normal = preload("res://Sprites/Flag Pack Opened.png")
		$"Extra Pack".offset_transform_position.x = -48
		$"Extra Pack"/Button.offset_transform_position.x = 48
		await get_tree().create_timer(0.25).timeout
		var camera_drag = create_tween()
		camera_drag.set_ease(Tween.EASE_IN_OUT)
		camera_drag.set_trans(Tween.TRANS_BACK)
		camera_drag.tween_property($Camera2D, "position", Vector2(-576, 324), 1)
		camera_drag.play()
		Globals.currency -= 500

func _on_extra_one_pressed() -> void:
	if extra_one == flag_stock.blue_flag:
		Globals.blue_flags += 5
	if extra_one == flag_stock.violet_flag:
		Globals.violet_flags += 5
	if extra_one == flag_stock.orange_flag:
		Globals.orange_flags += 5
	if extra_one == flag_stock.green_flag:
		Globals.green_flags += 5
	if extra_one == flag_stock.magenta_flag:
		Globals.magenta_flags += 5
	if extra_one == flag_stock.pink_flag:
		Globals.pink_flags += 5
	if extra_one == flag_stock.white_flag:
		Globals.white_flags += 5
	if extra_one == flag_stock.black_flag:
		Globals.black_flags += 5
	if extra_one == flag_stock.grey_flag:
		Globals.grey_flags += 5
	if extra_one == flag_stock.brown_flag:
		Globals.brown_flags += 5
	if extra_one == flag_stock.yellow_flag:
		Globals.yellow_flags += 5
	extra_pack_option_chosen = true

func _on_extra_two_pressed() -> void:
	if extra_two == flag_stock.blue_flag:
		Globals.blue_flags += 5
	if extra_two == flag_stock.violet_flag:
		Globals.violet_flags += 5
	if extra_two == flag_stock.orange_flag:
		Globals.orange_flags += 5
	if extra_two == flag_stock.green_flag:
		Globals.green_flags += 5
	if extra_two == flag_stock.magenta_flag:
		Globals.magenta_flags += 5
	if extra_two == flag_stock.pink_flag:
		Globals.pink_flags += 5
	if extra_two == flag_stock.white_flag:
		Globals.white_flags += 5
	if extra_two == flag_stock.black_flag:
		Globals.black_flags += 5
	if extra_two == flag_stock.grey_flag:
		Globals.grey_flags += 5
	if extra_two == flag_stock.brown_flag:
		Globals.brown_flags += 5
	if extra_two == flag_stock.yellow_flag:
		Globals.yellow_flags += 5
	extra_pack_option_chosen = true

func _on_extra_three_pressed() -> void:
	if extra_three == flag_stock.blue_flag:
		Globals.blue_flags += 5
	if extra_three == flag_stock.violet_flag:
		Globals.violet_flags += 5
	if extra_three == flag_stock.orange_flag:
		Globals.orange_flags += 5
	if extra_three == flag_stock.green_flag:
		Globals.green_flags += 5
	if extra_three == flag_stock.magenta_flag:
		Globals.magenta_flags += 5
	if extra_three == flag_stock.pink_flag:
		Globals.pink_flags += 5
	if extra_three == flag_stock.white_flag:
		Globals.white_flags += 5
	if extra_three == flag_stock.black_flag:
		Globals.black_flags += 5
	if extra_three == flag_stock.grey_flag:
		Globals.grey_flags += 5
	if extra_three == flag_stock.brown_flag:
		Globals.brown_flags += 5
	if extra_three == flag_stock.yellow_flag:
		Globals.yellow_flags += 5
	extra_pack_option_chosen = true
