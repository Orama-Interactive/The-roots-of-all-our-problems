extends Obstacle

enum RotationBehavior { ROT_FOLLOW_DIR, ROT_CONSTANT }
@export var rotation_behavior := RotationBehavior.ROT_FOLLOW_DIR


func _ready() -> void:
	jump_velocity = randf_range(-89000, -40000)
	super._ready()


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if not has_jumped:
		has_jumped = true
		velocity.y = jump_velocity * delta

	velocity.x = speed * delta
	if rotation_behavior == RotationBehavior.ROT_FOLLOW_DIR:
		$Area2D.rotation = velocity.angle()
	else:
		$Area2D.rotation += deg_to_rad(1)
	move_and_slide()
