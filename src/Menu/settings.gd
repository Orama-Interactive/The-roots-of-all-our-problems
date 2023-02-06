extends Control


func _ready() -> void:
	$VBoxContainer/AmbientSubs.grab_focus()


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func _on_ambient_subs_toggled(button_pressed: bool) -> void:
	GameManager.show_ambient_subtitles = button_pressed


func _on_microphone_input_toggled(button_pressed: bool) -> void:
	GameManager.play_with_voice = button_pressed
