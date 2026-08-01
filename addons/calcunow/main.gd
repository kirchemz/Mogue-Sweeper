@tool
extends EditorPlugin
var dock

func _enter_tree() -> void:
	dock = EditorDock.new()
	dock.title = "Calcunow"
	dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_BL
	dock.dock_icon = preload("res://addons/calcunow/icon.svg")
	var dock_content = preload("res://addons/calcunow/main.tscn").instantiate()
	dock.add_child(dock_content)
	add_dock(dock)


func _exit_tree() -> void:
	remove_dock(dock)
