extends Control


func _on_ambient_subs_toggled(button_pressed: bool) -> void:
	GameManager.show_ambient_subtitles = button_pressed


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
