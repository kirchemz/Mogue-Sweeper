extends Node2D

var ability_one : Dictionary
var ability_two : String
var ability_three : String
var stock : Dictionary = {
	"auto_chord" : {
		"name" : "Auto Chord",
		"price" : 100,
		"img" : preload("res://Sprites/Auto Chord.png")
	}
}

func _ready() -> void:
	ability_one = stock.auto_chord

func _process(delta: float) -> void:
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
	if ability_one == stock.auto_chord:
		Abilities.auto_chord = true
	$"Ability One".texture_normal = ability_one.img
	$"Ability One/Label".text = ability_one.name + ": " + str(ability_one.price)

func _on_texture_button_pressed() -> void:
	Globals.level_requirement += 50
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_ability_one_pressed() -> void:
	if Globals.currency >= ability_one.price:
		Globals.currency -= ability_one.price
		if ability_one == stock.auto_chord:
			Abilities.auto_chord = true
			Abilities.ability_one = ability_one
			
