extends Area2D

func _physics_process(delta):
	var mousePos = get_viewport().get_mouse_position()
	self.position = mousePos

func _on_body_entered(body):
	if body != null:
		if body.is_in_group("selectable"):
			body.hovered = true

func _on_body_exited(body):
	if body != null:
		if body.is_in_group("selectable"):
			body.hovered = false

func _on_area_entered(area):
	if area != null:
		if area.is_in_group("selectable"):
			area.hovered = true

func _on_area_exited(area):
	if area != null:
		if area.is_in_group("selectable"):
			area.hovered = false
