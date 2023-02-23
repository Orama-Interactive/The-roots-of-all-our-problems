extends Control

@onready var buttons: VBoxContainer = $Buttons
@onready var new_button: Button = $Buttons/New
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var intro_music: AudioStreamPlayer = $IntroMusic


func _ready() -> void:
	GameManager.play_music()
	new_button.grab_focus()
	if GameManager.menu_faded_in:
		$FadeIn.modulate.a = 0
	else:
		animation_player.play("fade_in")
		GameManager.menu_faded_in = true


func _on_new_pressed() -> void:
	animation_player.play("first_scene")
	for button in buttons.get_children():
		button.disabled = true
	var music_delay := 5.5
	GameManager.stop_music(music_delay)
	await get_tree().create_timer(music_delay).timeout
	intro_music.play()


func _on_load_pressed() -> void:
	GameManager.stop_music()
	GameManager.loaded = true
	get_tree().change_scene_to_file("res://src/Level.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/settings.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "first_scene":
		get_tree().change_scene_to_file("res://src/Level.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/credits.tscn")


func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Level.tscn")
