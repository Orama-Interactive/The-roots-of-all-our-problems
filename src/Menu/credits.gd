extends Control


func _input(event: InputEvent) -> void:
	if (event is InputEventKey
	or event is InputEventMouseButton
	or event is InputEventScreenTouch
	or event is InputEventJoypadButton):
		get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
