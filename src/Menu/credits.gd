extends Control

@export var scroll_speed := 40.0
@onready var header: Label = $Header
@onready var text: RichTextLabel = $Text
@onready var fade_in: ColorRect = $FadeIn


func _ready() -> void:
	text.text = tr(text.text)
	create_tween().tween_property(fade_in, "modulate", Color(1, 1, 1, 0), 1)


func _input(event: InputEvent) -> void:
	if (event is InputEventKey
	or event is InputEventMouseButton
	or event is InputEventScreenTouch
	or event is InputEventJoypadButton):
		create_tween().tween_property(fade_in, "modulate", Color(1, 1, 1, 1), 1).finished.connect(_go_to_menu)


func _process(delta: float) -> void:
	header.position.y -= scroll_speed * delta
	text.position.y -= scroll_speed * delta
	text.size.y += scroll_speed * delta


func _go_to_menu() -> void:
	GameManager.menu_faded_in = false
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
