extends RigidBody2D

var pos = Vector2(5,10)
var torque = 0

var vecX = 0
var vecY = 0
var leftRight = randi_range(0, 1)

func _ready():
	if leftRight == 1:
		vecX = vecX * -1
	apply_impulse(Vector2(vecX, vecY), pos)
	apply_torque_impulse(torque)

func _process(_delta):
	pass
