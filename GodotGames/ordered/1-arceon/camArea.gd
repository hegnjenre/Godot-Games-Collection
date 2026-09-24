extends Area3D

@onready var cam = $sceneCamera

func _process(delta):
	pass

func _on_body_entered(body):
	if body.name != "player":
		return
	else:
		cam.current = true
		cam.target = body
