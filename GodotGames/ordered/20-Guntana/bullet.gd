extends RigidBody2D

var boing = preload("res://arrow_static.tscn")

@export var bullet_speed = 1250
@export var damage = 1

var direction = Vector2(0,0)
var killTime = 6.0
var body = null
var staticPos = null
var noCollide = false

@onready var kill = $killTimer

func _ready():
	rotation = direction.angle()
	apply_central_impulse(direction * bullet_speed)
	kill.set_wait_time(killTime)
	kill.start()

func _process(_delta):
	pass
	#apply_central_force(Vector2.DOWN * 9.8) # used for gravity

func _on_kill_timer_timeout():
	if body != null:
		var newStatic = boing.instantiate()
		body.add_child(newStatic)
		if direction.x == -1:
			newStatic.flip_h = true
		newStatic.global_position = staticPos
		body.do_damage(damage)
	queue_free()
