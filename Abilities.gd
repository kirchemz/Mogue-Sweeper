extends Node

var current_abilities : Array = []

var ability_stock : Dictionary = {
	"auto_chord" : {
		"name" : "Auto Chord",
		"price" : 100,
		"img" : preload("res://Sprites/Auto Chord.png")
	}
}

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

var auto_chord : bool = false
var auto_chord_active : bool = false
