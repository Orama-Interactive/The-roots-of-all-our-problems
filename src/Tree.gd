extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collapse_direction := true if randi() % 2 == 0 else false
	if collapse_direction:
		animation_player.play("collapse_right")
	else:
		animation_player.play("collapse_left")
