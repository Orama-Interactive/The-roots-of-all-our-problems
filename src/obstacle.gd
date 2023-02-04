class_name Obstacle
extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")
var speed := -60000.0
var jump_velocity = -40000.0
var has_jumped := false


func _ready() -> void:
	jump_velocity = randf_range(-89000, -40000)


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if not has_jumped:
		has_jumped = true
		velocity.y = jump_velocity * delta

	velocity.x = speed * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Game over")


func _on_despawn_timer_timeout() -> void:
	queue_free()
