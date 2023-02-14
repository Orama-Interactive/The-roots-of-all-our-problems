class_name BackgroundObstacle
extends Area2D

var despawn_limit := 1000.0
var speed := 600.0
var player_pos := Vector2.ZERO
@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	position.x = player_pos.x + 1940


func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x <= despawn_limit:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.fall()
