@tool
extends Control

@onready var N1 := $HBox/N1
@onready var N2 := $HBox/N2
@onready var label := $Label
@onready var OptionBox := $HBox/OptionBox
@onready var Memory := $"Memory/Memory"
var operator := "+"


func _process(_delta: float) -> void:
	var n1 = float(N1.get_node("n1").text)
	var n2 = float(N2.get_node("n2").text)
	
	# check fraction 1
	if N1.get_node("n1f").visible:
		N1.get_node("n1f").visible = true
		n1 /= float(N1.get_node("n1f").text)
	else:
		N1.get_node("n1f").visible = false
	
	# check fraction 2
	if $"group/fraction2".button_pressed:
		N2.get_node("n2f").visible = true
		n2 /= float(N2.get_node("n2f").text)
	else:
		N2.get_node("n2f").visible = false
	
	# prob shouldnt do this every frame but oh well
	match operator:
		"+":
			label.text = str(n1 + n2)
		"-":
			label.text = str(n1 - n2)
		"*":
			label.text = str(n1 * n2)
		"d":
			label.text = str(n1 / n2)
		"^":
			label.text = str(pow(n1, n2))


func _on_n_1r_pressed() -> void: ## N1 = Result
	N1.get_node("n1").text = label.text


func _on_n_1n_2_pressed() -> void: ## Swap
	var swap:String = N1.get_node("n1").text
	N1.get_node("n1").text = N2.get_node("n2").text
	N2.get_node("n2").text = swap


func _on_n_2r_pressed() -> void: ## N2 = Result
	N2.get_node("n2").text = label.text


func _on_plus_pressed() -> void:
	# these 5 act the same
	# go to default position
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 0) 
	# set new operator
	operator = "+"
	# go to active position
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 5) 


func _on_minus_pressed() -> void:
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 0) 
	operator = "-"
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 5) 


func _on_multiply_pressed() -> void:
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 0) 
	operator = "*"
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 5) 


func _on_divide_pressed() -> void:
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 0) 
	operator = "d" # cant use / cause im not allowed to in node names
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 5) 


func _on_exponent_pressed() -> void: ## hidden as to reduce size, who uses exponents anyway
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 0) 
	operator = "^"
	(OptionBox.get_node(operator) as Button).offset_transform_position = Vector2(0, 5) 


func _on_n_1m_pressed() -> void: ## N1 = Memory
	N1.get_node(^"n1").text = Memory.get_item_text(Memory.selected)


func _on_n_2m_pressed() -> void: ## N2 = Memory
	N2.get_node(^"n2").text = Memory.get_item_text(Memory.selected)


func _on_add_pressed() -> void: ## add to memory
	Memory.add_item($Label.text)


func _on_del_pressed() -> void: ## delete memory
	Memory.remove_item(Memory.selected)


func _on_m_pressed() -> void: ## toggle memory
	if $Memory.visible:
		$Memory.hide()
	else:
		$Memory.show()
