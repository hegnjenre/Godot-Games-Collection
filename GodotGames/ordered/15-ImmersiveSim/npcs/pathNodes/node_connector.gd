extends Node3D

@onready var nodes = get_node("../pathNodes")
@onready var sceneRoot = get_node("..")
var nodeArray = []
var timerArray = []
var connected = false
var idx = 0
var timerIDX = 0
var loop = 0
var pathsReady = false

func _ready():
	var cCount = nodes.get_child_count()
	if cCount > 0:
		nodeArray = []
		idx = 0
		loop = 0
		for child in nodes.get_children():
			if child.pathID == idx:
				nodeArray.append(child)
			else:
				connectNodes(nodeArray)
				idx += 1
				nodeArray = []
				nodeArray.append(child)
			loop += 1
			connected = false
		if loop == cCount and connected == false: #for the last array of nodes when there is no way to reach the else statement
			connectNodes(nodeArray)
			idx = 0
			nodeArray = []

func _process(_delta):
	if pathsReady == false:
		pathsReady = true

func connectNodes(NA):
	connected = true
	var newPath = Path3D.new()
	var newFollow = PathFollow3D.new()
	var newCurve = Curve3D.new()
	var firstNode = NA[0]
	nodes.add_child(newPath)
	newPath.name = "Path" + str(idx)
	newPath.set_curve(newCurve)
	newPath.add_child(newFollow)
	newFollow.loop = false
	for node in NA:
		newPath.curve.add_point(node.get_global_position(), Vector3(0, 0, 0), Vector3(0, 0, 0))
		if node.pathLoop == true: #for looping paths
			newPath.curve.add_point(firstNode.get_global_position(), Vector3(0, 0, 0), Vector3(0, 0, 0))
		if node.pathTask == true:
			nodes.actionPositions.append(node.get_global_position())
			if node.waitTime > 0:
				var newTimer = Timer.new()
				newFollow.add_child(newTimer)
				newTimer.one_shot = true
				newTimer.name = "nodeTimer" + str(timerIDX)
				timerIDX += 1
				newTimer.wait_time = node.waitTime
				timerArray.append(newTimer)
	for i in range(0, NA.size()):
		var delNode = NA[0]
		NA.remove_at(0)
		delNode.queue_free()
		delNode = null
