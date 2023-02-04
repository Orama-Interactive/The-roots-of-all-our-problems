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

@onready var label: Label = $Label


func _ready() -> void:
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = text_size
	label.label_settings.font_color = text_color


func _on_mouse_entered() -> void:
	var tw := create_tween()
#	tw.tween_property(self, "custom_minimum_size", Vector2(320, 170), 1)
	tw.tween_property(self, "text_size", 150, 0.4)


func _on_mouse_exited() -> void:
	var tw := create_tween()
	tw.tween_property(self, "text_size", 128, 0.4)
#	tw.tween_property(self, "custom_minimum_size", Vector2(300, 150), 1)
#	tw.tween_property(self, "size", Vector2(300, 150), 1)


func _on_focus_entered() -> void:
	label.label_settings.font_color = text_color_hover


func _on_focus_exited() -> void:
	label.label_settings.font_color = text_color
