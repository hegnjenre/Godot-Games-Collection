extends Area3D

@onready var cam = get_node("../Camera3D")
@onready var mousePos = cam.mouseCollide
@onready var interactPos = cam.interactCollide
@onready var z = get_global_position().z

var hovered = null
var selected = null
var clicking = false

func _physics_process(_delta):
	mousePos = cam.mouseCollide
	interactPos = cam.interactCollide
	if interactPos != null and interactPos.has("collider") != true:
		interactPos = null
	if mousePos != null and mousePos.has("collider") != true:
		mousePos = null
		
	if mousePos != null:
		var newPos = Vector3(mousePos["position"].x, mousePos["position"].y, z)
		self.set_global_position(newPos)
	else:
		pass
		
	if interactPos != null and interactPos["collider"].is_in_group("physObj") == true and clicking == false:
		hovered = interactPos["collider"]
	elif interactPos == null and clicking:
		if selected != null:
			selected.interacting = false
		hovered = null
		selected = null
	
	if hovered != null and selected == null and clicking:
		selected = hovered
		selected.interacting = true
	actionListener()

func actionListener():
	if Input.is_action_just_pressed("LC"):
		clicking = true
	else:
		clicking = false
