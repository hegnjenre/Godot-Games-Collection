extends Camera3D

@onready var cam = self

var target = null

func _process(delta):
	if target == null:
		return
	else:
		cam.look_at(target.global_position)
