extends Node

const CONFIG_PATH := "user://save.cfg"

var loaded := false
var config_file := ConfigFile.new()
var show_ambient_subtitles := true


func save(checkpoint: int) -> void:
	config_file.set_value("progress", "checkpoint", checkpoint)
	config_file.save(CONFIG_PATH)


func load() -> int:
	config_file.load(CONFIG_PATH)
	var checkpoint = config_file.get_value("progress", "checkpoint", 0)
	return checkpoint
