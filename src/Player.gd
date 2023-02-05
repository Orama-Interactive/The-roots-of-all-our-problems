class_name Player
extends CharacterBody2D

const SPEED := 10000.0
const JUMP_VELOCITY: = -400.0

var can_move := true
var falling_sound := preload("res://assets/audio/sounds/dragonfly_2.wav")
var flying_sound := preload("res://assets/audio/sounds/dragonfly_3.wav")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var falling := false
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	start()


func start() -> void:
	animated_sprite_2d.play("default")


func _physics_process(delta: float):
	if not can_move:
		return
	# Add the gravity.
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, JUMP_VELOCITY, 1200)

	# Handle Jump.
	if not falling and Input.is_action_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		if animated_sprite_2d.speed_scale != 2:
			animated_sprite_2d.speed_scale = 2
			audio_stream_player.stream = flying_sound
			audio_stream_player.play()
	else:
		if animated_sprite_2d.speed_scale != 1:
			animated_sprite_2d.speed_scale = 1
			audio_stream_player.stream = falling_sound
			audio_stream_player.play()

	velocity.x = SPEED * delta
	move_and_slide()

	if position.y < -80 or position.y > 1160:
		GameManager.game_over()


func fall() -> void:
	animated_sprite_2d.play("fall")
	falling = true
