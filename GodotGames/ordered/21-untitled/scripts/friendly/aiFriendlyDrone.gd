extends "res://scripts/enemy/aiSuper.gd"

func follow(point, delta):
	if get_global_position().distance_to(point) > maxIdleRad:
		moveOut = 0
	if moveOut != 1:       ## not reached
		moveOut = move_to(point, delta)
	elif moveOut != 0 and !cooled:     ## idling
		pass

func drone_process(delta):
	locOut = locate_player_in_range()
	if locOut != null:
		targetPos = locOut
		targetRot = Vector2.UP.angle_to(targetPos-get_global_position())
		rot_to(targetRot)
		follow(targetPos, delta)
	else:
		print("player OOR")
