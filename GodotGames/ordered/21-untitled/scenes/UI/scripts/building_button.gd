extends Button

var building = null
var buildController = null

func _on_pressed() -> void:
	if buildController.selected != null:
		buildController.selected.queue_free()
	var newBuilding = building.instantiate()
	newBuilding.visible = false
	newBuilding.name = str(newBuilding.name) + str(Global.get_b_id())
	Global.get_world_root().add_child(newBuilding)
	buildController.selected = newBuilding
	buildController.selectedButton = self
