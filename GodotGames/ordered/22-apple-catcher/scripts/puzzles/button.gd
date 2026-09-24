extends Button

var wireType = null
var controller = null

func _on_pressed() -> void:
	if controller.selectedButton == null:
		controller.selectedType = wireType
		var wireOutline = wireType.instantiate()
		wireOutline.set_global_position(get_global_mouse_position())
		controller.add_child(wireOutline)
		controller.selected = wireOutline
		controller.selectedButton = self
	elif controller.selectedButton != self:
		controller.selected.queue_free()
		controller.selectedType = wireType
		var wireOutline = wireType.instantiate()
		wireOutline.set_global_position(get_global_mouse_position())
		controller.add_child(wireOutline)
		controller.selected = wireOutline
		controller.selectedButton = self
