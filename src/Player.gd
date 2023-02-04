class_name Player
extends CharacterBody2D

const SPEED := 10000.0
const JUMP_VELOCITY: = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float):
	# Add the gravity.
#	if not is_on_floor():
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	velocity.x = SPEED * delta
	move_and_slide()
