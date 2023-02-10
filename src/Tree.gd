extends Node2D

var speed := 100.0
var falling_sounds := [
	preload("res://assets/audio/sounds/tree_falling.wav"),
	preload("res://assets/audio/sounds/tree_falling_2.wav"),
	preload("res://assets/audio/sounds/tree_falling_3.wav"),
]
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	position.y += randf_range(20, 120)
	var scale_value := randf_range(0.6, 1)
	speed *= scale_value
	scale = Vector2(scale_value, scale_value)
	z_index = round(scale_value * 10)
	animated_sprite_2d.frame = randi() % 2
	animated_sprite_2d.flip_h = rand_bool()


func _process(delta: float) -> void:
	position.x -= speed * delta


func collapse() -> void:
	await get_tree().create_timer(randf_range(0.1, 2)).timeout
	var collapse_direction := rand_bool()
	if collapse_direction:
		animation_player.play("collapse_right")
	else:
		animation_player.play("collapse_left")
	$AudioStreamPlayer2D.stream = falling_sounds.pick_random()
	$AudioStreamPlayer2D.play()


func _on_despawn_timer_timeout() -> void:
	queue_free()


func rand_bool() -> bool:
	return true if randi() % 2 == 0 else false
