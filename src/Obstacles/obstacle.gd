class_name Obstacle
extends CharacterBody2D

enum Place { FLOOR, CEILING }

@export var place := Place.FLOOR
@export var can_flip := true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed := -60000.0
var jump_velocity = -40000.0
var has_jumped := false
var player_pos := Vector2.ZERO
@onready var sprite: Sprite2D = $Area2D/Sprite


func _ready() -> void:
#	var tex_size := sprite.texture.get_size()
	position.x = player_pos.x + 1940
	var rand_pos := randf_range(0.0, 100.0)
	position.y = 1080.0 + rand_pos if place == Place.FLOOR else -rand_pos
	scale.y = randf_range(1.0, 1.2)


func _physics_process(delta: float) -> void:
	velocity.x = speed * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.fall()


func _on_despawn_timer_timeout() -> void:
	queue_free()


func rand_bool() -> bool:
	return true if randi() % 2 == 0 else false
