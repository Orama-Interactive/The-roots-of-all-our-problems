extends Control

@onready var languages: VBoxContainer = $Languages
@onready var ambient_subs: CheckBox = $VBoxContainer/AmbientSubs
@onready var microphone_input: CheckBox = $VBoxContainer/MicrophoneInput
@onready var master_volume: TextureProgressBar = $VBoxContainer/MasterVolume
@onready var music_volume: TextureProgressBar = $VBoxContainer/MusicVolume
@onready var sounds_volume: TextureProgressBar = $VBoxContainer/SoundsVolume
@onready var narration_volume: TextureProgressBar = $VBoxContainer/NarrationVolume
@onready var mic_threshold: TextureProgressBar = $VBoxContainer/MicThreshold
@onready var master_volume_label: Label = $VBoxContainer/MasterVolumeLabel
@onready var music_volume_label: Label = $VBoxContainer/MusicVolumeLabel
@onready var sounds_volume_label: Label = $VBoxContainer/SoundsVolumeLabel
@onready var narration_volume_label: Label = $VBoxContainer/NarrationVolumeLabel
@onready var mic_threshold_label: Label = $VBoxContainer/MicThresholdLabel


func _ready() -> void:
	var current_locale := TranslationServer.get_locale()
	var loaded_locales := TranslationServer.get_loaded_locales()
	var language_button_group := ButtonGroup.new()
#	loaded_locales.sort()
	for locale in loaded_locales:
		var check_box := CheckBox.new()
		check_box.button_group = language_button_group
		check_box.name = TranslationServer.get_locale_name(locale)
		check_box.text = check_box.name
		if locale == current_locale or locale + "_" in current_locale:
			check_box.button_pressed = true
		check_box.pressed.connect(_on_language_pressed.bind(locale))
		languages.add_child(check_box)
	if not is_instance_valid(language_button_group.get_pressed_button()):
		var check_box := languages.get_node("English") as CheckBox
		check_box.button_pressed = true

	master_volume.grab_focus()
	ambient_subs.button_pressed = GameManager.show_ambient_subtitles
	microphone_input.button_pressed = GameManager.play_with_voice
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
	sounds_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))) * 100
	narration_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Narration"))) * 100
	mic_threshold.value = GameManager.mic_input_threshold * 100
	update_label_values()


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func _on_language_pressed(locale: String) -> void:
	TranslationServer.set_locale(locale)
	GameManager.change_font(theme)
	update_label_values()


func _on_ambient_subs_toggled(button_pressed: bool) -> void:
	GameManager.show_ambient_subtitles = button_pressed


func _on_microphone_input_toggled(button_pressed: bool) -> void:
	GameManager.play_with_voice = button_pressed
	mic_threshold.visible = button_pressed
	mic_threshold_label.visible = button_pressed


func _on_volume_slider_value_changed(value: float, bus: StringName) -> void:
	var bus_index := AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))
	update_label_values()


func _on_mic_threshold_value_changed(value: float) -> void:
	GameManager.mic_input_threshold = value / 100.0
	update_label_values()


# This is lazy, ideally the slider that has been edited should update only its corresponding label
func update_label_values() -> void:
	master_volume_label.text = tr("Master volume: %s") % master_volume.value
	music_volume_label.text = tr("Music volume: %s") % music_volume.value
	sounds_volume_label.text = tr("Sounds volume: %s") % sounds_volume.value
	narration_volume_label.text = tr("Narration volume: %s") % narration_volume.value
	mic_threshold_label.text = tr("Microphone input threshold: %s") % mic_threshold.value
