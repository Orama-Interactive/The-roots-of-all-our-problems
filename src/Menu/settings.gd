extends Control


func _ready() -> void:
	$VBoxContainer/AmbientSubs.grab_focus()


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func _on_ambient_subs_toggled(button_pressed: bool) -> void:
	GameManager.show_ambient_subtitles = button_pressed


func _on_microphone_input_toggled(button_pressed: bool) -> void:
	GameManager.play_with_voice = button_pressed


func _on_volume_slider_value_changed(value: float) -> void:
	if is_zero_approx(value):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))
