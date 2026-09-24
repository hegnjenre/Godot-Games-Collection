extends Node2D

var startPoint = get_global_position()
var intermediaries = []
var finalPath = [Vector2()]
var debug = false
var ep = null

@onready var ray = $RayCast2D
@onready var line = $Line2D
@onready var spr = $Sprite2D

func _ready():
	line.add_point(to_local(get_global_position()))

func build_path(endPoint):
	line.clear_points()
	line.add_point(to_local(get_global_position()))
	ray.target_position = to_local(endPoint)
	ep = endPoint
	ray.force_raycast_update()
	if ray.is_colliding(): # need to find correct path
		var cPoint = ray.get_collision_point()
		spr.visible = true
		spr.global_position = cPoint
	else: # straight line is correct path
		line.add_point(to_local(endPoint)) ## local points for Line2D
		finalPath.append(endPoint) ## global points for moving
	
	return finalPath

func clear_path():
	line.clear_points()
	finalPath.clear()
	finalPath = [Vector2()]

func _process(_delta):
	if line.points.size() > 1:
		line.set_point_position(0, to_local(global_position))
		line.set_point_position(1, to_local(ep))

