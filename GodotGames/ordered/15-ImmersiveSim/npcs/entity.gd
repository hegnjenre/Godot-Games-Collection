extends CharacterBody3D

@export var speed = 10.0
var currentSpeed = speed
@export var actionKeys = []

@onready var paths = get_node("../pathNodes")
@onready var nodeConnector = get_node("../nodeConnector")
@onready var timerNodes = nodeConnector.timerArray
@onready var animator = $animator

var CAID = 0 #CurrentActionID
var AIDX = 0 #ActionInDeX
var SAIDX = 0 #SubActionInDeX
var actionComplete = false
var onPath = false
var currentPathFollow = null
var reparented = false
var tasking = false
var timerIDX = 0
var timerStop = true

func _physics_process(_delta):
	if actionComplete == true:
		actionComplete = false
		SAIDX = 0
	if onPath == true and currentPathFollow != null:
		currentPathFollow.progress += currentSpeed * 0.01
		var ratioRounded = snapped(currentPathFollow.progress_ratio, 0.01)
		if is_equal_approx(1, ratioRounded) == true: #checks current progress and comparaes with progress of previous frame
			if paths.actionPositions.size() > 0 and AIDX < paths.actionPositions.size():
				var posRounded = round(self.get_global_position())
				var actionPosRounded = round(paths.actionPositions[AIDX])
				if posRounded == actionPosRounded and tasking == false and timerStop == true:
					currentSpeed = 0
					animator.play(actionKeys[SAIDX])#would like this to be a library maybe? so it's more reliable
					SAIDX += 1
					tasking = true
					timerStop = false
					timerNodes[timerIDX].start()
					
				elif animator.is_playing() == false and timerStop == false:
					animator.play(actionKeys[SAIDX])
					if timerNodes[timerIDX].is_stopped() == true:
						timerStop = true
						animator.stop()
						SAIDX += 1
						animator.play(actionKeys[SAIDX])
					
				elif animator.is_playing() == false and timerStop == true:
					reparented = false
					CAID += 1
					AIDX += 1
					actionComplete = true
					currentSpeed = speed
					initNextPath()
			else:
				reparented = false
				CAID += 1
				initNextPath()
	else:
		initNextPath()

func initNextPath():
	tasking = false
	if nodeConnector.pathsReady == true:
		if CAID > (paths.get_child_count()-1): #loop back to beginning of action 'list'
			CAID = 0
			AIDX = 0
		var currentPath = paths.get_child(CAID)
		#print(currentPath)
		var newFollow = currentPath.get_child(0)
		currentPathFollow = newFollow
		currentPathFollow.progress = 0.0
		#print(currentPathFollow)
		if reparented == false:
			self.global_position = currentPathFollow.get_global_position()
			self.reparent(currentPathFollow)
			reparented = true
		onPath = true
