extends "res://interactiveStatic/prop.gd"

var opened = false #prevents a second 90 turn when reentering collision shape after opening once

func _ready():
	object = $doorPivot

func open():
	if opened == false:
		object.rotate_object_local(Vector3(0,1,0), deg_to_rad(90))
		opened = true
	elif opened == true:
		object.rotate_object_local(Vector3(0,1,0), deg_to_rad(-90))
		opened = false

