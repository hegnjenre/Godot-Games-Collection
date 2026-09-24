extends CharacterBody2D

const SPEED = 15.0
var direction = 0.0
var focused = false

func _physics_process(_delta: float) -> void:
	if focused:
		direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_collide(velocity)
