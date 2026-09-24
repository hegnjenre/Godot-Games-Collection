extends "res://scripts/enemy/aiSuper.gd"

@onready var laserScene = preload("res://scenes/effects/laser.tscn")
@onready var laserPoint = $AnimatedSprite2D/laserPoint
@onready var tileset = Global.get_tileset()

var tileChosen = false
var chosenTile = Vector2()
var tilesGrouped = false
var tilesGroup = {}
var dist_dir_from_player = {"dist":Vector2(), "dir":Vector2()}
var maxRange = 220.0
var minRange = 140.0

func follow(point, delta): ## constant movement toward moving point
	if moveOut != 1:       ## not reached
		moveOut = move_to(point, delta)
	elif moveOut != 0:     ## idling
		##attack
		pass

func drone_process(delta):
	# find point within range to stop at and shoot at player
	# if player leaves search range then find new point.
	if currentTarget == null:
		locOut = locate_target_in_range()
	else:
		locOut = locate_target_in_range(currentTarget)
	
	if get_global_position().distance_to(locOut) > maxRange:
		tilesGroup.clear()
		tileChosen = false
		tilesGrouped = false
		moveOut = 0
		follow(locOut, delta)
	elif get_global_position().distance_to(locOut) < maxRange && get_global_position().distance_to(locOut) > minRange:
		follow(locOut, delta)
	elif (get_global_position().distance_to(locOut) < minRange) && (!tileChosen && !tilesGrouped):
		for tileKey in player.tilesInRange.keys():
			if tilesGroup.size() < 10:
				tilesGroup.get_or_add(tileKey, [player.tilesInRange.get(tileKey), get_global_position().distance_to(tileKey)])
			else:
				var maxDist = 0
				var max = Vector2()
				for tilesGroupKey in tilesGroup.keys():
					if tilesGroup.get(tilesGroupKey)[1] > maxDist:
						maxDist = tilesGroup.get(tilesGroupKey)[1]
						max = tilesGroupKey
				if get_global_position().distance_to(tileKey) < maxDist:
					tilesGroup.erase(max)
					tilesGroup.get_or_add(tileKey, [player.tilesInRange.get(tileKey), get_global_position().distance_to(tileKey)])
					tilesGrouped = true
			
	elif (get_global_position().distance_to(locOut) < minRange) && !tileChosen:
		var randTile = randi_range(0,9)
		var keys = tilesGroup.keys()
		chosenTile = keys[randTile]
		tileChosen = true
		dist_dir_from_player.set("dist", player.get_global_position().distance_to(chosenTile))
		dist_dir_from_player.set("dir", player.get_global_position().direction_to(chosenTile))
		moveOut = 0
		
	if locOut != null:
		targetRot = Vector2.UP.angle_to(locOut-get_global_position())
		rot_to(targetRot)
		if tileChosen && moveOut != 1:
			if moveOut == 0:       ## not reached
				##print(get_global_position().direction_to(closest_dir().get_global_position()))
				moveOut = move_to(chosenTile, delta)
		elif moveOut == 1:
			if !cooled:     ## idling
				shoot_at_dir(currentTarget.get_global_position())
		
	
	############### following:
	#if Input.is_action_just_pressed("rightClick"):
		#locOut = locate_target_in_range(player)
	#if currentTarget == null:
		#locOut = locate_target_in_range()
	#else:
		#locOut = locate_target_in_range(currentTarget)
	#if locOut != null:
		#targetPos = locOut
		#targetRot = Vector2.UP.angle_to(targetPos-get_global_position())
		#rot_to(targetRot)
		#follow(targetPos, delta)
	#else:
		#pass
		##print("player OOR")

func shoot_at_dir(point):
	var laser = laserScene.instantiate()
	#print("fire at " + str(get_global_position().direction_to(point)))
	laser.set_global_position(laserPoint.get_global_position())
	Global.get_root().add_child(laser)
	laser.set_direction(point)
	attackCooldown.start()
	cooled = true

func _on_timer_timeout():
	cooled = false

func _ready():
	objId = Global.add_obj(self)
	$AnimatedSprite2D.play("default")
	$detection/CollisionShape2D.shape.radius = detectRad
	#print(str($maxRad/CollisionShape2D.shape.radius) + " -> " + str(maxIdleRad))
	targetPos = get_global_position()
	attackCooldown.wait_time = attTimerCooldown
