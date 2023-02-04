extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/New.grab_focus()


func _on_new_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/settings.tscn")
