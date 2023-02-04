extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")
var tree_tscn := preload("res://src/tree.tscn")
@onready var player: Player = $Player
@onready var tree_parent: Node2D = $TreeParent


func _on_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	var pos := Vector2(player.position.x + 1540, 1080)
	obstacle.position = pos
	add_child(obstacle)

	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
