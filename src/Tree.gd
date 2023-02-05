extends Node2D

var speed := 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	position.y += randf_range(20, 120)
	var scale_value := randf_range(0.6, 1)
	speed *= scale_value
	scale = Vector2(scale_value, scale_value)
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


func _on_despawn_timer_timeout() -> void:
	queue_free()


func rand_bool() -> bool:
	return true if randi() % 2 == 0 else false
