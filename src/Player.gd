class_name Player
extends CharacterBody2D

signal fell

const SPEED := 10000.0
const JUMP_VELOCITY: = -400.0
const INVINCIBILITY_SECONDS := 3.0
const SHAKE_DECAY_RATE := 0.7
const CAMERA_MAX_OFFSET := Vector2(100, 0)
const TRAUMA_POWER := 3

var can_move := false
var can_get_hit := true
var tutorial_shown := false
var flying_sound := preload("res://assets/audio/sounds/dragonfly_2.ogg")
var flying_sound_2 := preload("res://assets/audio/sounds/dragonfly_3.ogg")
var falling_sound := preload("res://assets/audio/sounds/player_fall.mp3")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var falling := false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var record_bus_index: int
var noise_i := 0.0
var trauma := 0.0
var noise := FastNoiseLite.new()

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var falling_sound_player: AudioStreamPlayer = $FallingSoundPlayer
@onready var audio_stream_record: AudioStreamPlayer = $AudioStreamRecord


func _ready() -> void:
	noise.frequency = 1
	record_bus_index = AudioServer.get_bus_index("Record")
	start()
	if GameManager.play_with_voice:
		audio_stream_record.play()


func start() -> void:
	animated_sprite_2d.play("default")
	make_invincible()


func make_invincible(seconds: float = INVINCIBILITY_SECONDS) -> void:
	if can_move:
		can_get_hit = false
		_flash_invincible()
		await get_tree().create_timer(seconds, false).timeout
		can_get_hit = true


func _process(delta: float) -> void:
	trauma = max(trauma - SHAKE_DECAY_RATE * delta, 0)
	_shake()


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
	velocity.y = clampf(velocity.y, JUMP_VELOCITY, 1200)
	var mic_input := false
	if GameManager.play_with_voice:
		mic_input = _get_mic_input() > GameManager.mic_input_threshold
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


func fall() -> void:
	if not can_get_hit:
		return
	if not falling:
		trauma = 1.0
		falling_sound_player.stream = falling_sound
		falling_sound_player.play()
		animated_sprite_2d.play("fall")
		falling = true
		emit_signal("fell")


func _shake() -> void:
	var shake_amount := pow(trauma, TRAUMA_POWER)
	noise_i += 1
	camera_2d.offset.x = CAMERA_MAX_OFFSET.x * shake_amount * noise.get_noise_1d(noise_i)


func _flash_invincible() -> void:
	if can_get_hit:
		return
	var tween := create_tween()
	tween.tween_property(animated_sprite_2d, "modulate", Color(1, 1, 1, 0), 0.1)
	tween.tween_property(animated_sprite_2d, "modulate", Color(1, 1, 1, 1), 0.1)
	tween.finished.connect(_flash_invincible)


func _get_mic_input() -> float:
	var sample := AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var linear_sample := db_to_linear(sample)
	return linear_sample
