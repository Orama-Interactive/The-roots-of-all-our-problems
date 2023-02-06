extends Node

const CONFIG_PATH := "user://save.cfg"

var loaded := false
var config_file := ConfigFile.new()
var show_ambient_subtitles := true
var play_with_voice := false


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
#	get_tree().reload_current_scene() # Why does this crash?
