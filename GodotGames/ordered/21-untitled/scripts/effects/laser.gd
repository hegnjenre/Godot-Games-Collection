extends CharacterBody2D

const speed = 200
var direction = Vector2()
var randTilt = 0

@onready var killTimer = $Timer

func _ready():
	randTilt = randf_range(-0.04, 0.04)

func _process(delta):
	move_and_collide(direction*speed*delta)

#Vector2(clampf((direction.x + randTilt), 0.0, 1.0), clampf((direction.y + randTilt), 0.0, 1.0))

func set_direction(point):
	killTimer.start()
	direction = Vector2((get_global_position().direction_to(point).x + randTilt), (get_global_position().direction_to(point).y + randTilt))
	set_rotation(Vector2.UP.angle_to(Vector2(point.x + randTilt, point.y + randTilt)-get_global_position()))

func _on_timer_timeout():
	queue_free()
