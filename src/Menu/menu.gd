extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/New.grab_focus()


func _on_exit_pressed() -> void:
	get_tree().quit()
