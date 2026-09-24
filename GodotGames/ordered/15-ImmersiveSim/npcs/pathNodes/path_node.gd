extends Node3D

@export var pathID = 0
@export var pathLoop = false
#variable for path connecting back to beginning: false is terminate, true is loop
#only needed for the last node in a path ^
@export var pathTask = false
#variable for when an action should be performed when reaching a certain node
@export var waitTime = 0
