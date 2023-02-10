extends Control

@onready var ambient_subs: CheckBox = $VBoxContainer/AmbientSubs
@onready var microphone_input: CheckBox = $VBoxContainer/MicrophoneInput
@onready var master_volume: TextureProgressBar = $VBoxContainer/MasterVolume
@onready var music_volume: TextureProgressBar = $VBoxContainer/MusicVolume
@onready var sounds_volume: TextureProgressBar = $VBoxContainer/SoundsVolume
@onready var narration_volume: TextureProgressBar = $VBoxContainer/NarrationVolume


func _ready() -> void:
	$VBoxContainer/AmbientSubs.grab_focus()
	ambient_subs.button_pressed = GameManager.show_ambient_subtitles
	microphone_input.button_pressed = GameManager.play_with_voice
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
	sounds_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds"))) * 100
	narration_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Narration"))) * 100


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func _on_ambient_subs_toggled(button_pressed: bool) -> void:
	GameManager.show_ambient_subtitles = button_pressed


func _on_microphone_input_toggled(button_pressed: bool) -> void:
	GameManager.play_with_voice = button_pressed


func _on_volume_slider_value_changed(value: float, bus: StringName) -> void:
	var bus_index := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))
