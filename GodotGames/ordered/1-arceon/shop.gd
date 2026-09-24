extends Node3D

@export var item1 = Node3D
@export var item2 = Node3D
@export var item3 = Node3D
@export var item4 = Node3D
@export var item5 = Node3D

@onready var itemPoints = $itemPoints
@onready var camera = $shopCam
@onready var player = get_node("/root/home/player") 

var items = [item1, item2, item3, item4, item5]
var activated = false
var mouse = Vector2()

func _ready():
	for i in range (0, itemPoints.get_child_count()):
		if items[i] != Node3D:
			items[i].global_position = itemPoints.get_child(i).get_global_position()

func _input(event):
	if event is InputEventMouse and activated == true:
		mouse = event.position
		get_selection(event)

func get_selection(event):
	var worldspace = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var from = cam.project_ray_origin(event.position)
	var to = from + cam.project_ray_normal(event.position) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = worldspace.intersect_ray(query)
	
	if len(result) > 0: #prevent crash when not clicking on collider
		for point in itemPoints.get_children():
			if len(point.get_children()) > 0:
				var selected = point.get_child(0)
				if result.collider == selected:
					selected.outline()
					if event is InputEventMouseButton and event.pressed == true and event.button_index == 1:
						selected.clicked()
						player.addToInv(selected)
				else:
					selected.outlined = false
	else:
		for point in itemPoints.get_children():
			if len(point.get_children()) > 0:
				var selected = point.get_child(0)
				selected.outlined = false
	
