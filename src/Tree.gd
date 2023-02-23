class_name BackgroundTree
extends Node2D

var speed := 100.0
var falling_sounds := [
	preload("res://assets/audio/sounds/tree_falling_2.ogg"),
	preload("res://assets/audio/sounds/tree_falling_3.ogg"),
]
var despawn_limit := 1000.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var frame_index := randi() % animated_sprite_2d.sprite_frames.get_frame_count("default")
#	position.y = animated_sprite_2d.sprite_frames.get_frame_texture("default", frame_index).get_height()
	position.y += randf_range(20, 120)
	var scale_value := randf_range(0.6, 1)
	speed *= scale_value
	scale = Vector2(scale_value, scale_value)
	z_index = round(scale_value * 10)
	animated_sprite_2d.frame = frame_index
	animated_sprite_2d.flip_h = rand_bool()


func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x <= despawn_limit:
		queue_free()


func collapse() -> void:
	await get_tree().create_timer(randf_range(0.1, 2), false).timeout
	var collapse_direction := rand_bool()
	if collapse_direction:
		animation_player.play("collapse_right")
	else:
		animation_player.play("collapse_left")
	$AudioStreamPlayer2D.stream = falling_sounds.pick_random()
	$AudioStreamPlayer2D.play()


func rand_bool() -> bool:
	return true if randi() % 2 == 0 else false
