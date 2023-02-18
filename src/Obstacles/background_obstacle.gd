class_name BackgroundObstacle
extends Area2D

var despawn_limit := 1000.0
var speed := 600.0
var start_pos := Vector2.ZERO
var scene: PackedScene
var spawn_timer := 1.0
@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	position.x = start_pos.x + 1940
	await get_tree().create_timer(spawn_timer).timeout
	var level: Level = get_parent()
	var sprite_width := sprite.texture.get_width()
	var obstacle: BackgroundObstacle = scene.instantiate()
	obstacle.start_pos.x = position.x + sprite_width - 1940
	obstacle.start_pos.y = start_pos.y
	obstacle.despawn_limit = level.calculate_checkpoint_position(level.current_checkpoint) - sprite_width - 400
	obstacle.scene = scene
	obstacle.spawn_timer = spawn_timer
	add_sibling(obstacle)


func _process(delta: float) -> void:
	position.x -= speed * delta
	if position.x <= despawn_limit:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.fall()
