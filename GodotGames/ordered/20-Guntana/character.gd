extends CharacterBody2D

var bulletRes = preload("res://bullet.tscn")

@export var SPEED = 100.0
@export var MELEE_DAMAGE = 2.0
@export var STOP_SPEED = 6.0
@export var JUMP_HEIGHT = 225.0
var accelerating = -80
var gravity = 9.8

var L = false
var R = false

var inputLR = false
var input_dir = 0.0
var jump_input = false
var jump_cool = false
var attack_cool = false
var jump_replace = true
var att_anim_done = false
var jump_anim_done = false
var att_default = true
var jump_default = true

var in_range = false
var targets = []

@onready var root = get_node("/root/debug")
@onready var vel_label = $debug/debugText/ProgressBar
@onready var input_label = $debug/debugText/input_dir
@onready var laser_point = $laserPoint
@onready var laser_mesh = $laser
@onready var shot_ray = $shotRay
@onready var melee_collide = $attackArea/CollisionShape2D
@onready var melee_r = $MarkerR
@onready var melee_l = $MarkerL

@onready var attack_anim = $attackAnimation
@onready var jump_anim = $jumpAnimation
@onready var sprite = $body

func _unhandled_input(event):
	if event.is_action_pressed("right"):
		flip_char('R')
		accelerating = -80
		inputLR = true
		R = true
		input_dir = 1.0
		if L:                ## cancel out opposites
			inputLR = false
	elif event.is_action_released("right"):
		inputLR = false
		R = false
		if L:                ## check if still holding left
			inputLR = true
		input_dir = -1.0                 ## stopping direction is opposite to moving direction
	if event.is_action_pressed("left"):
		flip_char('L')
		accelerating = -80
		inputLR = true
		L = true
		input_dir = -1.0
		if R:                ## cancel out opposites
			inputLR = false
	elif event.is_action_released("left"):
		inputLR = false
		L = false
		if R:                ## check if still holding right
			inputLR = true
		input_dir = 1.0                  ## stopping direction is opposite to moving direction
	if event.is_action_pressed("jump"):
		remove_child(jump_anim)
		root.add_child(jump_anim) ## this stuff should be its own function, same with shooting, but I don't want to rn
		jump_anim.play("jump")
		jump_replace = false
		jump_default = false
		jump_input = true
		gravity = 6.5          ## if jump held then jump for longer (gravity lower = more airtime)
	elif event.is_action_released("jump"):
		jump_input = false
		jump_cool = false
		JUMP_HEIGHT = 225.0
		gravity = 9.8
	if event.is_action_pressed("shoot") and attack_cool == false:
		ranged_attack()
	if event.is_action_released("shoot"):
		attack_cool = false ## might need to change
	if event.is_action_pressed("attack") and attack_cool == false:
		attack_anim.play("attack")
		att_default = false
		attack_cool = true
		## do attack animation
		for target in targets:
			## need to add delay for animation maybe?
			target.do_damage(MELEE_DAMAGE)
	if event.is_action_released("attack"):
		attack_cool = false

func _process(_delta):
	move_and_jump()
	if att_anim_done == true:
		attack_anim.play("default")
		att_anim_done = false
	if jump_anim_done == true:
		jump_anim.play("default")
		jump_anim_done = false
	

func ranged_attack():
	if laser_mesh.points.size() > 1:
		laser_mesh.remove_point(1)
	laser_mesh.add_point(to_local(get_global_mouse_position()))
	
	var rand_y = randf_range(0, 0.06) ## applies slightly random y direction to the shot so it's not perfect 
	var shot_dir = Vector2(direction_to_cursor(shot_ray.global_position).x, direction_to_cursor(shot_ray.global_position).x + rand_y)
	shot_ray.force_raycast_update()
	var collide = shot_ray.get_collider()
	var collidePoint = shot_ray.get_collision_point()
	
	var newShot = bulletRes.instantiate()
	if collide != null and collide.is_in_group("enemy"):
		var killTime = calc_kill_time(collidePoint, newShot.bullet_speed)
		newShot.killTime = killTime
		newShot.body = collide
		newShot.staticPos = Vector2(collidePoint.x, (collidePoint.y + (rand_y*100))) ## adjusts boing pos for random
	
	newShot.direction = -shot_dir
	root.add_child(newShot)
	newShot.global_position = laser_point.global_position
	


func flip_char(dir):
		if dir == 'R':
			shot_ray.position = Vector2(7,-31)
			shot_ray.target_position = Vector2(1200,0)
			melee_collide.set_global_position(melee_r.get_global_position())
			attack_anim.set_global_position(melee_r.get_global_position())
			sprite.flip_h = false
			attack_anim.flip_h = false
			jump_anim.flip_h = false
		elif dir == 'L':
			shot_ray.position = Vector2(-7,-31)
			shot_ray.target_position = Vector2(-1200,0)
			melee_collide.set_global_position(melee_l.get_global_position())
			attack_anim.set_global_position(melee_l.get_global_position())
			sprite.flip_h = true
			attack_anim.flip_h = true
			jump_anim.flip_h = true

func direction_to_cursor(point):
	return (point-get_global_mouse_position()).normalized()##make node topoint at mouse and use thast dir

func direction(point): ## can be used to find if any point is left or right of the player body
	if point > self.global_position.x:
		return Vector2(-1,0) # right
	else:
		return Vector2(1,0) # left

func move_and_jump():
	vel_label.value = abs(velocity.x)
	input_label.text = ("Input Direction: " + str(input_dir))
	if is_on_floor():
		velocity.y = 0.0
		if jump_replace == false:
			root.remove_child(jump_anim)
			add_child(jump_anim)
			jump_replace = true
		if jump_input and jump_cool == false:
			jump_cool = true
			velocity.y = -JUMP_HEIGHT
	else:
		velocity.y += gravity ## apply gravity if not on ground
	if !inputLR:
		if accelerating > -80:        ## slowly decrease acceleration so stop start is more natural
			accelerating -= 10
		if (abs(velocity.x) - STOP_SPEED > 0.0):       ## come to a stop rather than instant
				velocity.x += (STOP_SPEED * input_dir)
		else:
			velocity.x = 0.0                        ## make sure we full stop
	else:
		velocity.x = ((SPEED + accelerating) * input_dir)
		if accelerating < 0.0:
			accelerating += 10                      ## accelerate up to full speed
	move_and_slide() ## apply

func calc_kill_time(end, shotSpeed): ## time for the shot to be killed and replaced not enemy kill
	var dist = laser_point.global_position.distance_to(end)
	var killTime = (dist/shotSpeed)
	return killTime

func _on_attack_area_body_entered(body):
	if body.is_in_group("enemy"):
		targets.append(body)
		in_range = true                   ## will probably be unneeded but might as well
		print("target: " + str(targets))

func _on_attack_area_body_exited(body):
	for i in range(0, len(targets)):
		if targets[i] == body:
			targets.remove_at(i)
			in_range = false
			print("target: " + str(targets))

func _on_attack_animation_animation_finished():
	if att_default == false: #prevent default from activating this
		att_default = true
		att_anim_done = true

func _on_jump_animation_animation_finished():
	if jump_default == false: #prevent default from activating this
		jump_default = true
		jump_anim_done = true
