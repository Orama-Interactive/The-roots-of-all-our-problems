extends Control


func _ready() -> void:
	$AnimationPlayer.play("ending")
	if get_theme_default_font().font_name == "Mandy's Sketch":
		$WhiteBars/ColorRect2.position = Vector2i(175, 893)
		$WhiteBars/ColorRect2.size = Vector2i(67, 55)
		$WhiteBars/ColorRect3.position = Vector2i(988, 889)
		$WhiteBars/ColorRect3.size = Vector2i(62, 55)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://src/Menu/credits.tscn")
