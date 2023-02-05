extends Control

@export var scroll_speed := 40.0
@onready var header: Label = $Header
@onready var by_orama: Label = $ByOrama
@onready var text: RichTextLabel = $Text



func _input(event: InputEvent) -> void:
	if (event is InputEventKey
	or event is InputEventMouseButton
	or event is InputEventScreenTouch
	or event is InputEventJoypadButton):
		get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func _process(delta: float) -> void:
	header.position.y -= scroll_speed * delta
	by_orama.position.y -= scroll_speed * delta
	text.position.y -= scroll_speed * delta
	text.size.y += scroll_speed * delta
