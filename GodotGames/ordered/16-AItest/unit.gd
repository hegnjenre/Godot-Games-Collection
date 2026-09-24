extends CharacterBody2D

var mouse_in = false
var chosen = false
var follow = false
var pathArray = []

var maxSpeed = 100.0
var acceleration = 10.0

@onready var pointer = $pointer

func _ready():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("lClick") && mouse_in == true && chosen == false:
		chosen = true
		print(self.name + "chosen: " + str(chosen))
	elif event.is_action_pressed("lClick") && mouse_in == false && chosen == true:
		chosen = false
		print(self.name + "chosen: " + str(chosen))
	elif event.is_action_pressed("rClick") && chosen == true:
		pointer.clear_path()
		pathArray.clear()
		pathArray = pointer.build_path(get_global_mouse_position())
		#print(pathArray)

func within_area(currentPoint, endPoint): ## this means ending within a certain area of endpoint
	var range = 5
	#print(!(currentPoint.x > endPoint.x - 10 && currentPoint.y < endPoint.y + 10 && currentPoint.x < endPoint.x + 10 && currentPoint.y > endPoint.y - 10))
	return ((currentPoint.x > endPoint.x - range) && (currentPoint.y < endPoint.y + range) && (currentPoint.x < endPoint.x + range) && (currentPoint.y > endPoint.y - range))

func _process(delta):
	if !pathArray.is_empty() && pathArray.size() > 1 && !within_area(global_position, pathArray[1]):
		set_global_position(get_global_position().move_toward(pathArray[1], delta*maxSpeed)) ## edit this to add acceleration
	elif !pathArray.is_empty() && pathArray.size() > 1 && within_area(global_position, pathArray[1]):
		print("finished")
		pathArray.clear()
		pointer.clear_path()

func _on_mouse_entered():
	mouse_in = true
	print(self.name + "mouse:" + str(mouse_in))

func _on_mouse_exited():
	mouse_in = false
	print(self.name + "mouse:" + str(mouse_in))
