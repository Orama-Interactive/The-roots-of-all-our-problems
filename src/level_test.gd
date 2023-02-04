extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")
var tree_tscn := preload("res://src/tree.tscn")
@onready var player: Player = $Player
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	var pos := Vector2(player.position.x + 1940, 1080)
	obstacle.position = pos
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var pos := Vector2(player.position.x + 2040, 1080)
	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
	tree_timer.wait_time = randf_range(1, 7)
