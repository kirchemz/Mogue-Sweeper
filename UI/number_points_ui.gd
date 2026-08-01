extends Control


func _on_texture_button_pressed() -> void:
	$".".visible = false
	get_parent().get_parent().get_node("Timer").paused = false
	get_parent().get_parent().ui_shown = false

func _process(delta: float) -> void:
	if Abilities.the_mowl_the_marrier:
		$"1/ProgressBar".visible = true
		$"2/ProgressBar".visible = true
		$"3/ProgressBar".visible = true
		$"4/ProgressBar".visible = true
		$"5/ProgressBar".visible = true
		$"6/ProgressBar".visible = true
		$"7/ProgressBar".visible = true
		$"8/ProgressBar".visible = true
		$"9/ProgressBar".visible = true
		$"1/ProgressBar".value = Abilities.ones_cleared
		$"2/ProgressBar".value = Abilities.twos_cleared
		$"3/ProgressBar".value = Abilities.threes_cleared
		$"4/ProgressBar".value = Abilities.fours_cleared
		$"5/ProgressBar".value = Abilities.fives_cleared
		$"6/ProgressBar".value = Abilities.sixes_cleared
		$"7/ProgressBar".value = Abilities.sevens_cleared
		$"8/ProgressBar".value = Abilities.eights_cleared
		$"9/ProgressBar".value = Abilities.nines_cleared
	else:
		$"1/ProgressBar".visible = false
		$"2/ProgressBar".visible = false
		$"3/ProgressBar".visible = false
		$"4/ProgressBar".visible = false
		$"5/ProgressBar".visible = false
		$"6/ProgressBar".visible = false
		$"7/ProgressBar".visible = false
		$"8/ProgressBar".visible = false
		$"9/ProgressBar".visible = false
	$"1/Label".text = "Mult:
		" + str(Globals.ones_points.mult)
	$"1/Label2".text = "Points:
		" + str(Globals.ones_points.points)
	$"2/Label".text = "Mult:
		" + str(Globals.twos_points.mult)
	$"2/Label2".text = "Points:
		" + str(Globals.twos_points.points)
	$"3/Label".text = "Mult:
		" + str(Globals.threes_points.mult)
	$"3/Label2".text = "Points:
		" + str(Globals.threes_points.points)
	$"4/Label".text = "Mult:
		" + str(Globals.fours_points.mult)
	$"4/Label2".text = "Points:
		" + str(Globals.fours_points.points)
	$"5/Label".text = "Mult:
		" + str(Globals.fives_points.mult)
	$"5/Label2".text = "Points:
		" + str(Globals.fives_points.points)
	$"6/Label".text = "Mult:
		" + str(Globals.sixes_points.mult)
	$"6/Label2".text = "Points:
		" + str(Globals.sixes_points.points)
	$"7/Label".text = "Mult:
		" + str(Globals.sevens_points.mult)
	$"7/Label2".text = "Points:
		" + str(Globals.sevens_points.points)
	$"8/Label".text = "Mult:
		" + str(Globals.eights_points.mult)
	$"8/Label2".text = "Points:
		" + str(Globals.eights_points.points)
	$"9/Label".text = "Mult:
		" + str(Globals.nines_points.mult)
	$"9/Label2".text = "Points:
		" + str(Globals.nines_points.points)
