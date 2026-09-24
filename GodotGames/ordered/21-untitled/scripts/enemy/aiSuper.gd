extends CharacterBody2D

var objId = 0
var hub = null
var targetPos = null
var targetRot = null
var moveOut = 1 ## prevent move_to call without cause
var locOut = 0
var currentSpeed = 0.0
var lastDir = null
var targetReached = false
var incompleteMove = false
var cooled = false

var debugFollow = false

var detected = []
var currentTarget = null

@export var topSpeed = 100.0
@export var rotSpeed = 1 ## time in seconds to rotate to target
@export var maxIdleRad = 10.0
@export var minIdleRad = 10.0
@export var IdleTime = 2.0
@export var accRate = 5.0
@export var slowRate = 5.0
@export var detectRad = 1200.0
@export var attTimerCooldown:float = 2.0
@export var enabled = true

@onready var player = Global.get_player()
@onready var sprite = $AnimatedSprite2D
@onready var attackCooldown = $Timer

func rot_to(to):
	if to != null:
		var from = sprite.rotation
		var newTurn = get_tree().create_tween()
		newTurn.tween_method(func (compRatio): 
				sprite.rotation = lerp_angle(from, to, compRatio), 0.0, 1.0, rotSpeed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

#####need to rethink how i want these enemies to behave

func move_to(point, delta):
	if point != null:
		var completeRadii = [Vector2(point.x-maxIdleRad, point.y-maxIdleRad), Vector2(point.x+maxIdleRad, point.y+maxIdleRad)]
		var currentPos = get_global_position()
		
		#print("speed: " + str(currentSpeed))
		
		## this is good enough for now, in future it should be done differently though
		## vector force-like directional motion rather than just speed in one direction 
		## changing direction mid motion continues with current speed even if opposite directions <-
		
		if targetReached == true && ((currentPos.x < completeRadii[0].x || currentPos.x > completeRadii[1].x) || (currentPos.y < completeRadii[0].y || currentPos.y > completeRadii[1].y)) && currentSpeed == 0:
			#print("not within")
			targetReached = false
		
		elif (targetReached != true) && !((currentPos.x >= completeRadii[0].x && currentPos.x <= completeRadii[1].x) && (currentPos.y >= completeRadii[0].y && currentPos.y <= completeRadii[1].y)): 
			#print("accel")
			move_and_collide(currentPos.direction_to(point) * currentSpeed * delta)
			lastDir = currentPos.direction_to(point)
			if currentSpeed < topSpeed:
				currentSpeed += accRate
		
		elif (targetReached == true) && currentSpeed > 0.0:
			#print("decel")
			move_and_collide(lastDir * currentSpeed * delta)
			currentSpeed -= slowRate
			currentSpeed = clampf(currentSpeed, 0.0, 999)
		
		elif targetReached != true && ((currentPos.x >= completeRadii[0].x && currentPos.x <= completeRadii[1].x) && (currentPos.y >= completeRadii[0].y && currentPos.y <= completeRadii[1].y)):
			#print("reached")
			targetReached = true
		
		elif targetReached == true && currentSpeed == 0.0:
			print("within")
			targetReached = false
			return 1
		
		return 0
	else:
		return null

func follow(point, delta): ## constant movement toward moving point
	if moveOut != 1:       ## not reached
		moveOut = move_to(point, delta)
	elif moveOut != 0:     ## idling
		##attack
		pass

func locate_target_in_range(target = null):
	if target == null: ## random
		target = detected[randi_range(0, detected.size()-1)]
	## specified
	currentTarget = target
	return target.get_global_position()

func locate_player_in_range():
	if get_global_position().distance_to(player.get_global_position()) <= detectRad:
		return player.get_global_position()
	else:
		return null ## out of range

func idle_at_target():
	pass

func idle_at_hub(hub):
	pass

func drone_process(delta): ## different process for each type of enemy, polymorphic
	##################################################
	if Input.is_action_just_pressed("leftClick"):
		targetPos = get_global_mouse_position()
		targetRot = Vector2.UP.angle_to(targetPos-get_global_position())
		rot_to(targetRot)
		moveOut = 0        ## activate move_to calls
	if moveOut == 0 and !debugFollow:
		moveOut = move_to(targetPos, delta)
	elif moveOut == null:
		print("Invalid Target Location")
		targetPos = get_global_position()
		moveOut = 1        ## disable move_to calls
	if Input.is_action_just_pressed("rightClick"):
		locOut = locate_target_in_range(player)
		currentTarget = locOut
	##################################################

func _ready():
	objId = Global.add_obj(self)
	$AnimatedSprite2D.play("default")
	$detection/CollisionShape2D.shape.radius = detectRad
	#print(str($maxRad/CollisionShape2D.shape.radius) + " -> " + str(maxIdleRad))
	targetPos = get_global_position()
	attackCooldown.wait_time = attTimerCooldown

func _process(delta):
	if enabled:
		drone_process(delta)

func _on_detection_body_entered(body): 
	if body.name != "tiles":
		if detected.size() >= 2:
			var dmin = 0
			var dmax = (detected.size()-1)
			var found = false
			
			while (dmin <= dmax) && found == false:
				var mid = dmin + (dmax - dmin)
				#print(body.name + " " + str(body.objId))
				#print(detected[mid].name + " " + str(detected[mid].objId))
				if body.objId > detected[mid].objId && mid+1 == detected.size():
					found = true
					detected.insert(mid+1, body)
				elif body.objId < detected[mid].objId && mid-1 < 0:
					found = true
					detected.insert(mid, body)
				elif body.objId > detected[mid].objId && body.objId < detected[mid+1].objId:
					found = true
					detected.insert(mid+1, body)
				elif body.objId < detected[mid].objId && body.objId > detected[mid-1].objId:
					found = true
					detected.insert(mid, body)
				elif body.objId < detected[mid].objId:
					dmax = mid-1
				elif body.objId > detected[mid].objId:
					dmin = mid+1
		else:
			if detected.is_empty():
				detected.append(body)
			else:
				if detected[0].objId < body.objId:
					detected.insert(1, body)
				else:
					detected.insert(0, body)
		#print(detected)

func _on_detection_body_exited(body):
	if body.name != "tiles":
		if !detected.is_empty():
			var dmin = 0
			var dmax = (detected.size()-1)
			var found = false
			
			while (dmin <= dmax) && found == false:
				var mid = dmin + (dmax - dmin)
				#print(body.name + " " + str(body.objId))
				#print(detected[mid].name + " " + str(detected[mid].objId))
				if body.objId < detected[mid].objId:
					dmax = mid-1
				elif body.objId > detected[mid].objId:
					dmin = mid+1
				elif body.objId == detected[mid].objId:
					found = true
					#print("found at " + str(mid))
					detected.remove_at(mid)
		#print(detected)
