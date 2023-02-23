extends Node

const CONFIG_PATH := "user://save.cfg"

var loaded := false
var config_file := ConfigFile.new()
var show_ambient_subtitles := true
var play_with_voice := false
var mic_input_threshold := 0.2
var menu_faded_in := false

@onready var sound_player: AudioStreamPlayer = $SoundPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer


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
	var tutorial := tr("Hold any key to fly\nRelease to fall")
	if DisplayServer.is_touchscreen_available():
		tutorial = tr("Touch and hold to fly\nRelease to fall")
	if play_with_voice:
		tutorial = tr("Talk to fly\nStop talking to fall")

	get_tree().current_scene.tutorial.text = tutorial


func play_sound(audio: AudioStream) -> void:
	sound_player.stream = audio
	sound_player.play()


func play_music(audio: AudioStream = null) -> void:
	if music_player.playing:
		if not audio or audio == music_player.stream:
			return
	if audio:
		music_player.stream = audio
	music_player.play()


func stop_music(duration := 1.0) -> void:
	create_tween().tween_property(music_player,"volume_db", -100, duration).finished.connect(music_player.stop)
