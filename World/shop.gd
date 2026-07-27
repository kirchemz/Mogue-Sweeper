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
var pack_opened : bool = false
var pack_option_chosen : bool = false

var rock_stock : Dictionary = {
	"granite" : {
		"name" : "Granite",
		"img" : preload("res://Sprites/Granite.png"),
		"rarity" : 30,
		"price" : 100
	},
	"quartz" : {
		"name" : "Quartz",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 30,
		"price" : 100
	},
	"basalt" : {
		"name" : "Basalt",
		"img" : preload("res://Sprites/Basalt.png"),
		"rarity" : 20,
		"price" : 100
	},
	"obsidian" : {
		"name" : "Obsidian",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 10,
		"price" : 100
	},
	"fluorite" : {
		"name" : "Fluorite",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 10,
		"price" : 100
	},
	"diamond" : {
		"name" : "Diamond",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 5,
		"price" : 100
	},
	"emerald" : {
		"name" : "Emerald",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 5,
		"price" : 100
	},
	"black_opal" : {
		"name" : "Black Opal",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 1,
		"price" : 100
	},
	"red_diamond" : {
		"name" : "Red Diamond",
		"img" : preload("res://Sprites/Cell.png"),
		"rarity" : 1,
		"price" : 100
	}
}

var ability_stock : Dictionary = {
	"auto_chord" : {
		"name" : "Auto Chord",
		"price" : 100,
		"img" : preload("res://Sprites/Auto Chord.png")
	}
}

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

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.475, 0.255, 0.0, 1.0))
	flag_options = [flag_stock.blue_flag, flag_stock.violet_flag, flag_stock.yellow_flag, flag_stock.orange_flag, flag_stock.magenta_flag, flag_stock.pink_flag, flag_stock.black_flag, flag_stock.brown_flag, flag_stock.white_flag, flag_stock.grey_flag]
	rock_options = [rock_stock.granite, rock_stock.quartz, rock_stock.basalt, rock_stock.obsidian, rock_stock.fluorite, rock_stock.diamond, rock_stock.emerald, rock_stock.black_opal, rock_stock.red_diamond]
	ability_one = ability_stock.auto_chord
	flag_one = choose_flag()
	flag_options.erase(flag_one)
	flag_two = choose_flag()
	flag_options.erase(flag_two)
	flag_three = choose_flag()
	flag_options.erase(flag_three)
	rock_one = choose_rock()
	rock_options.erase(rock_one)
	rock_two = choose_rock()
	rock_options.erase(rock_two)
	rock_three = choose_rock()
	rock_options.erase(rock_three)

func _process(delta: float) -> void:
	if pack_option_chosen:
		var camera_drag = create_tween()
		await get_tree().create_timer(0.25).timeout
		camera_drag.set_ease(Tween.EASE_IN_OUT)
		camera_drag.set_trans(Tween.TRANS_BACK)
		camera_drag.tween_property($Camera2D, "position", Vector2(576, 324), 1)
		camera_drag.play()
	$"Ability 1".texture_normal = Abilities.ability_one.img
	$"Ability 1/Label".text = Abilities.ability_one.name
	$"Ability 2".texture_normal = Abilities.ability_two.img
	$"Ability 2/Label".text = Abilities.ability_two.name
	$"Ability 3".texture_normal = Abilities.ability_three.img
	$"Ability 3/Label".text = Abilities.ability_three.name
	$"Ability 4".texture_normal = Abilities.ability_four.img
	$"Ability 4/Label".text = Abilities.ability_four.name
	$"Ability 5".texture_normal = Abilities.ability_five.img
	$"Ability 5/Label".text = Abilities.ability_five.name
	$NinePatchRect2/Label.text = str(Globals.currency)
	if ability_one == ability_stock.auto_chord:
		Abilities.auto_chord = true
	$"Ability One".texture_normal = ability_one.img
	$"Ability One/Label".text = ability_one.name + ": " + str(ability_one.price)
	$"Flag One".texture_normal = flag_one.img
	$"Flag One/Label".text = flag_one.name + ": " + str(flag_one.price)
	$"Flag Two".texture_normal = flag_two.img
	$"Flag Two/Label".text = flag_two.name + ": " + str(flag_two.price)
	$"Flag Three".texture_normal = flag_three.img
	$"Flag Three/Label".text = flag_three.name + ": " + str(flag_three.price)
	$"Rock One".texture_normal = rock_one.img
	$"Rock One/Label".text = rock_one.name + ": " + str(rock_one.price)
	$"Rock Two".texture_normal = rock_two.img
	$"Rock Two/Label".text = rock_two.name + ": " + str(rock_two.price)
	$"Rock Three".texture_normal = rock_three.img
	$"Rock Three/Label".text = rock_three.name + ": " + str(rock_three.price)

func _on_texture_button_pressed() -> void:
	Globals.level_requirement += 50
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_ability_one_pressed() -> void:
	if Globals.currency >= ability_one.price:
		Globals.currency -= ability_one.price
		if ability_one == ability_stock.auto_chord:
			Abilities.auto_chord = true
			Abilities.ability_one = ability_one

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

func choose_flag():
	var total_weight : int = 0
	
	for flag in flag_options:
		total_weight += flag.rarity
	
	var chosen_flag : float = randf() * total_weight
	
	for flag in flag_options:
		if chosen_flag < flag.rarity:
			return flag
		chosen_flag -= flag.rarity
	
	return flag_options[-1]

func choose_rock():
	var total_weight : int = 0
	
	for rock in rock_options:
		total_weight += rock.rarity
	
	var chosen_rock : float = randf() * total_weight
	
	for rock in rock_options:
		if chosen_rock < rock.rarity:
			return rock
		chosen_rock -= rock.rarity
	
	return rock_options[-1]

func _on_texture_button_2_pressed() -> void:
	opening_pack = true
	$TextureButton2.texture_normal = preload("res://Sprites/Rock Pack Opened.png")
	$TextureButton2.offset_transform_position.x = -48
	$TextureButton2/Button.offset_transform_position.x = 48
	await get_tree().create_timer(0.25).timeout
	var camera_drag = create_tween()
	camera_drag.set_ease(Tween.EASE_IN_OUT)
	camera_drag.set_trans(Tween.TRANS_BACK)
	camera_drag.tween_property($Camera2D, "position", Vector2(1728, 324), 1)
	camera_drag.play()


func _on_button_pressed() -> void:
	opening_pack = true
	$TextureButton2.texture_normal = preload("res://Sprites/Rock Pack Opened.png")
	$TextureButton2.offset_transform_position.x = -48
	$TextureButton2/Button.offset_transform_position.x = 48
	await get_tree().create_timer(0.25).timeout
	var camera_drag = create_tween()
	camera_drag.set_ease(Tween.EASE_IN_OUT)
	camera_drag.set_trans(Tween.TRANS_BACK)
	camera_drag.tween_property($Camera2D, "position", Vector2(1728, 324), 1)
	camera_drag.play()


func _on_rock_one_pressed() -> void:
	if rock_one == rock_stock.granite:
		Globals.upgrade_ones()
		pack_option_chosen = true


func _on_rock_two_pressed() -> void:
	if rock_one == rock_stock.granite:
		Globals.upgrade_ones()
		pack_option_chosen = true


func _on_rock_three_pressed() -> void:
	if rock_one == rock_stock.granite:
		Globals.upgrade_ones()
		pack_option_chosen = true
