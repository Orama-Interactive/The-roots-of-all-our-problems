class_name Obstacle
extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")
var speed := -60000.0
var jump_velocity = -40000.0
var has_jumped := false


func _ready() -> void:
	position.y = 1080


func _physics_process(delta: float) -> void:
	velocity.x = speed * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.game_over()


func _on_despawn_timer_timeout() -> void:
	queue_free()
