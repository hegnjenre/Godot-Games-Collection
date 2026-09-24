extends "res://enemy.gd"

var placeholder = preload("res://placeholder_point.tscn")

@onready var path = self.get_parent()
@onready var root = get_node("/root")

var curPos = Vector2()
var prevPos = Vector2()
var waiting = false
var waited = false #has recently waited
var waitTime = (randi_range(2, 4) * 100)
var decision = false
var playerPos = Vector2()
var direction = 0
var stoppingPoint = Vector2()
var cover = false
var uncover = false
var hiding = false
var aimingCircleAnim = false
var runstart = false
var running = false
var coveredAnim = false
var aimingAnim = false

func _process(delta):
	var vision = visionCast.get_collider()
	if vision != null:
		if vision.name == "player":
			attacking = true
			idle = false
			playerPos = vision.get_global_position()
	
	curPos = self.get_global_position()
	if killed != true:
		if idle == true:
			decision = false
			if waiting != true:
				waitTime = (randi_range(2, 4) * 100)
			if (snappedf(path.progress_ratio, 0.1) == 0.5 or snappedf(path.progress_ratio, 0.1) == 1) and waitTime > 0 and waited == false:
				waiting = true
				waitTime -= 1
				pathMoving = false
				animator.play("idle")
				#print(waitTime)
			else:
				waiting = false
				pathMoving = true
				animator.play("walk")
			if (snappedf(path.progress_ratio, 0.1) == 0.5 or snappedf(path.progress_ratio, 0.1) == 1) and waitTime <= 0:
				waited = true
			if (snappedf(path.progress_ratio, 0.1) > 0.5 and snappedf(path.progress_ratio, 0.1) < 1) or (snappedf(path.progress_ratio, 0.1) >= 0.1 and snappedf(path.progress_ratio, 0.1) < 0.5):
				waited = false
		
			if pathMoving == true:
				path.progress += speed * delta
				#print(snappedf(path.progress_ratio, 0.1))
				if curPos.x < prevPos.x:
					self.get_child(0).flip_h = true
					visionCast.target_position = Vector2(-200, 0)
				elif curPos.x > prevPos.x:
					self.get_child(0).flip_h = false
					visionCast.target_position = Vector2(200, 0)
			
			prevPos = curPos
		
		elif attacking == true:
			if decision == false:
				decision = true
				stoppingPoint = findCover()
			
			if int(stoppingPoint.x) - 2 > int(curPos.x):
				if running == false:
					animator.play("run")
				elif running == true and animator.get_frame() == 8: #loops the run cycle
					animator.set_frame(2)
				
				direction = 1
				running = true
			elif int(stoppingPoint.x) + 2 < int(curPos.x):
				if running == false:
					animator.play("run")
				elif running == true and animator.get_frame() == 8:
					animator.set_frame(2)
				
				direction = -1
				running = true
			else:
				if coveredAnim == false:
					coveredAnim = true
					animator.play("cover")
				
				direction = 0
				if uncover == false:
					cover = true
				runstart = false
				running = false
				
			velocity.x = direction * sprintSpeed
			move_and_slide()
			
			if cover == true:
				#animation and collisions for hiding behind the crate
				if hiding == false:
					waitTime = (randi_range(1, 1.5) * 100)
					hiding = true
				elif hiding == true:
					waitTime -= 1
				if uncover == false and waitTime <= 0:
					uncover = true
					cover = false
					hiding = false
				
			elif uncover == true:
				#animation for aiming at player
				if aimingCircleAnim == false:
					aimingUI.visible = true
					aimingUI.play("enemyAiming")
					aimingCircleAnim = true
				
				if attackWindup > 0:
					attackWindup -= 1
					print(attackWindup)
					
				else:
					if aimingAnim == false:
						animator.play("coverShoot")
						aimingAnim = true
					if animator.frame == 3:
						animator.play("shoot")
						aimingUI.visible = false
	else:
		aimingUI.visible = false


func findCover():
	var leftCollide = leftCast.get_collider()
	var rightCollide = rightCast.get_collider()
	var coverPos = Vector2()
	
	if playerPos.x < curPos.x:
		if leftCollide != null:
			var obstPos = leftCast.get_collision_point()
			coverPos = Vector2((obstPos.x + 10), 0)
			var instance = placeholder.instantiate()
			instance.global_position = coverPos
			root.call_deferred("add_child", instance)
		elif rightCollide != null:
			pass
	elif playerPos.x > curPos.x:
		if rightCollide != null:
			var obstPos = rightCast.get_collision_point()
			coverPos = Vector2((obstPos.x - 10), 0)
			var instance = placeholder.instantiate()
			instance.global_position = coverPos
			root.call_deferred("add_child", instance)
		elif leftCollide != null:
			pass
	
	return coverPos
	
