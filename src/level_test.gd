extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")
@onready var player: Player = $Player


func _on_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	var pos := Vector2(player.position.x + 940, 720)
	obstacle.position = pos
	add_child(obstacle)
