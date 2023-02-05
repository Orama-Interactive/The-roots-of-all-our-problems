extends Control


func _ready() -> void:
	$AnimationPlayer.play("ending")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
