class_name Player
extends CharacterBody2D

signal fell

const SPEED := 10000.0
const JUMP_VELOCITY: = -400.0

var can_move := false
var tutorial_shown := false
var flying_sound := preload("res://assets/audio/sounds/dragonfly_2.wav")
var flying_sound_2 := preload("res://assets/audio/sounds/dragonfly_3.wav")
var falling_sound := preload("res://assets/audio/sounds/player_fall.mp3")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var falling := false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var record_bus_index: int
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var falling_sound_player: AudioStreamPlayer = $FallingSoundPlayer
@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	record_bus_index = AudioServer.get_bus_index("Record")
	start()


func start() -> void:
	animated_sprite_2d.play("default")


func _physics_process(delta: float):
	if not can_move:
		velocity.x = SPEED * delta
		move_and_slide()
		if not tutorial_shown and position.x >= 810:
			tutorial_shown = true
			can_move = true
			GameManager.show_tutorial()
		return

	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, JUMP_VELOCITY, 1200)
	var mic_input := get_mic_input() > 0.2 if GameManager.play_with_voice else false
	var jump := Input.is_anything_pressed() or mic_input
	if Input.is_action_pressed("pause"):
		jump = false
	if not falling:
		if jump:
			velocity.y = JUMP_VELOCITY
			if animated_sprite_2d.speed_scale != 3:
				animated_sprite_2d.speed_scale = 3
				audio_stream_player.stream = flying_sound_2
				audio_stream_player.play()
		else:
			if animated_sprite_2d.speed_scale != 1:
				animated_sprite_2d.speed_scale = 1
				audio_stream_player.stream = flying_sound
				audio_stream_player.play()

	velocity.x = SPEED * delta
	move_and_slide()

	if position.y > 1160:
		GameManager.game_over()


func get_mic_input() -> float:
	var sample := AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample := db_to_linear(sample)
	return linear_sample


func fall() -> void:
	if not falling:
		falling_sound_player.stream = falling_sound
		falling_sound_player.play()
		animated_sprite_2d.play("fall")
		falling = true
		emit_signal("fell")
