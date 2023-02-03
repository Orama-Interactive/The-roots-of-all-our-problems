extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")


func _on_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	obstacle.position = Vector2(800, 400)
	add_child(obstacle)
