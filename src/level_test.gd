extends Node2D

var obstacle_tscn := preload("res://src/obstacle.tscn")
var tree_tscn := preload("res://src/tree.tscn")
var checkpoints: Array[float] = [0, 2000, 5000]
var current_checkpoint := 0
@onready var player: Player = $Player
@onready var tree_parent: Node2D = $TreeParent
@onready var tree_timer: Timer = $TreeTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(_delta: float) -> void:
	var pos := round(player.position.x)
	$CanvasLayer/Label.text = str(pos)
	if current_checkpoint >= checkpoints.size() -1:
		return
	if pos >= checkpoints[current_checkpoint + 1]:
		current_checkpoint += 1
		change_checkpoint()


func change_checkpoint() -> void:
	match current_checkpoint:
		1:
			animation_player.play("forest_fade_1")
		2:
			animation_player.play("forest_fade_2")


func _on_obstacle_timer_timeout() -> void:
	var obstacle: Obstacle = obstacle_tscn.instantiate()
	var pos := Vector2(player.position.x + 1940, 0)
	obstacle.position = pos
	add_child(obstacle)


func _on_tree_timer_timeout() -> void:
	var pos := Vector2(player.position.x + 2040, 1080)
	var tree := tree_tscn.instantiate()
	tree.position = pos
	tree_parent.add_child(tree)
	if player.position.x > checkpoints[2]:
		tree_timer.wait_time = randf_range(4, 7)
	elif player.position.x > checkpoints[1]:
		tree_timer.wait_time = randf_range(1, 4)
	else:
		tree_timer.wait_time = randf_range(0.2, 2)
