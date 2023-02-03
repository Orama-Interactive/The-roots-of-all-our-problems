class_name Obstacle
extends Area2D

var speed := 300.0


func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	position.y += speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Game over")
	
