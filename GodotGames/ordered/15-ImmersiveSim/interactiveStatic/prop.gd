extends Node3D

@export var object:Node3D
@export var objectTitle = ""
@export var objectInfo = ""

@onready var root = get_tree().get_root().get_child(0)
@onready var player = root.get_node("character")

var display = false
var interactable = false

func _on_trigger_area_body_entered(body):
	if body.name != "character":
		return
	else:
		interactable = true
		player.interactVisible = true

func _on_trigger_area_body_exited(body):
	if body.name != "character":
		return
	else:
		interactable = false
		display = false
		player.interactVisible = false
