class_name Player
extends CharacterBody2D

const SPEED := 10000.0
const JUMP_VELOCITY: = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.play("default")


func _physics_process(delta: float):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_pressed("jump"):
		animated_sprite_2d.speed_scale = 2
		velocity.y = JUMP_VELOCITY
	else:
		animated_sprite_2d.speed_scale = 1

	velocity.x = SPEED * delta
	move_and_slide()
