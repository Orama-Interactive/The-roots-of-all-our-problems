extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func collapse() -> void:
	var collapse_direction := true if randi() % 2 == 0 else false
	if collapse_direction:
		animation_player.play("collapse_right")
	else:
		animation_player.play("collapse_left")
