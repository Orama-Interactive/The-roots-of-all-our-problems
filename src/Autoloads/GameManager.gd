extends Node

const CONFIG_PATH := "user://save.cfg"

var loaded := false
var config_file := ConfigFile.new()
var show_ambient_subtitles := true
var play_with_voice := false
var mic_input_threshold := 0.2

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _input(event: InputEvent) -> void:
	if get_tree().current_scene.name != "Level":
		return
	if not event is InputEventMouseMotion:
		if get_tree().paused:
			get_tree().paused = false
			get_tree().current_scene.tutorial.text = ""


func save_game(checkpoint: int) -> void:
	config_file.set_value("progress", "checkpoint", checkpoint)
	config_file.save(CONFIG_PATH)


func load_game() -> int:
	config_file.load(CONFIG_PATH)
	var checkpoint = config_file.get_value("progress", "checkpoint", 0)
	return checkpoint


func game_over() -> void:
	if get_tree().current_scene.name != "Level":
		return
	loaded = true
	var player: Player = get_tree().current_scene.player
	player.falling = false
	player.start()
	get_tree().current_scene.go_to_checkpoint()
	get_tree().current_scene.enable_bottom_limit()


func show_tutorial() -> void:
	if get_tree().current_scene.name != "Level":
		return
	get_tree().paused = true
	var tutorial := "Hold any key to fly\nRelease to fall"
	if DisplayServer.is_touchscreen_available():
		tutorial = "Touch and hold to fly\nRelease to fall"
	if play_with_voice:
		tutorial = "Talk to fly\nStop talking to fall"

	get_tree().current_scene.tutorial.text = tutorial


func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
