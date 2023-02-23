@tool
extends Button

@export var actual_text := "":
	set(value):
		actual_text = value
		$Label.text = value

@export var text_size := 128:
	set(value):
		text_size = value
		$Label.label_settings.font_size = value

@export var text_color := Color(0.3, 0.3, 0.3, 1)
@export var text_color_hover := Color.BLACK
@export var outline_size := 0
@export var outline_color := Color.WHITE

@onready var label: Label = $Label

var sound := preload("res://assets/audio/sounds/pageturn-102978.mp3")
var initial_text_size: int


func _ready() -> void:
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = text_size
	label.label_settings.font_color = text_color
	label.label_settings.outline_size = outline_size
	label.label_settings.outline_color = outline_color
	initial_text_size = text_size


func _on_mouse_entered() -> void:
	create_tween().tween_property(self, "text_size", initial_text_size + 22, 0.1)


func _on_mouse_exited() -> void:
	create_tween().tween_property(self, "text_size", initial_text_size, 0.1)


func _on_focus_entered() -> void:
	label.label_settings.font_color = text_color_hover


func _on_focus_exited() -> void:
	label.label_settings.font_color = text_color


func _on_pressed() -> void:
	GameManager.play_sound(sound)
