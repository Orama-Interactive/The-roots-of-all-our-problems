extends Control


func _ready() -> void:
	$AnimationPlayer.play("splash")


func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
