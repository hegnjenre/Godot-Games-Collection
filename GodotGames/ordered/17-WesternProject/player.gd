extends CharacterBody2D

@onready var crosshair = $crosshair
@onready var crossCollider = $crossCollider
@onready var playerBody = $bodygroup
@onready var playerAnim = $bodygroup/body
@onready var rotArm = $bodygroup/armPart1
@onready var gunArm = $bodygroup/armPart1/armPart2
@onready var crouchPos = $bodygroup/crouchNode
@onready var weapon = $bodygroup/armPart1/armPart2/weapon
@onready var attack = weapon.get_child(0)
@onready var ammoCounter = $UI/ammoCount
@onready var armPoint = $bodygroup/armPart1/armPoint
@onready var rotPoint = $bodygroup/armPart1/armPart2/rotatePoint
@onready var aimP = $bodygroup/armPart1/armPart2/aimPrevent
@onready var rotPointOG = $bodygroup/armPart1/armPart2/rotatePointOG
@onready var recoilPoint = $bodygroup/armPart1/armPart2/rotatePoint/recoilPoint
@onready var slideTimer = $slideTimer
@onready var shotdirection = rad_to_deg(attack.get_global_rotation())
@onready var ogArmPos = rotArm.get_global_position()

@onready var charCollide = $collider
@onready var crouchCollide = $crouchCollide
@onready var slideCollide = $slideCollide

const SPEED = 65.0
const SPRINTSPEED = 140.0
const SLIDESPEED = 240.0
const CROUCHSPEED = 40.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var crosshairMove = true 
var cont = true
var right = true
var left = false
var sprint = false
var crouch = false
var walking = false
var slide = false
var slideTimeout = false
var recoil = false
var flipped = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(delta):
	ammoCounter.text = "Ammo: " + str(attack.currentAmmo)
	shotdirection = attack.get_global_rotation()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("sprint") and sprint == false:
		sprint = true
	elif Input.is_action_just_pressed("sprint") and sprint == true:
		sprint = false
	
	if Input.is_action_just_pressed("crouch") and crouch == false:
		crouch = true
		playerAnim.play("crouch")
		rotArm.global_position = crouchPos.get_global_position()
		charCollide.disabled = true
		crouchCollide.disabled = false
		slideCollide.disabled = true
	elif Input.is_action_just_pressed("crouch") and crouch == true:
		crouch = false
		playerAnim.play("idle")
		charCollide.disabled = false
		crouchCollide.disabled = true
		slideCollide.disabled = true
		if is_on_floor():
			rotArm.global_position.y = ogArmPos.y
	
	if Input.is_action_just_pressed("crouch") and slide == false and sprint == true and walking == true and slideTimeout == false:
		charCollide.disabled = true
		crouchCollide.disabled = true
		slideCollide.disabled = false
		slide = true
		sprint = false
		slideTimer.start(2)
	if slide == true and slideTimeout == true:
		crouch = true
		charCollide.disabled = true
		crouchCollide.disabled = false
		slideCollide.disabled = true
		slide = false
		playerAnim.play("crouch")
		slideTimeout = false
	
	
	var direction = Input.get_axis("left", "right")
	if direction and (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and sprint != true and slide != true and crouch == false:
		charCollide.disabled = false
		crouchCollide.disabled = true
		slideCollide.disabled = true
		
		if direction and Input.is_action_pressed("left") and crosshair.get_global_position().x < self.get_global_position().x:
			playerAnim.play("walk")
		if direction and Input.is_action_pressed("right") and crosshair.get_global_position().x > self.get_global_position().x:
			playerAnim.play("backwalk")
		elif direction and Input.is_action_pressed("right") and crosshair.get_global_position().x < self.get_global_position().x:
			playerAnim.play("walk")
		elif direction and Input.is_action_pressed("left") and crosshair.get_global_position().x > self.get_global_position().x:
			playerAnim.play("backwalk")
		
		velocity.x = direction * SPEED
		walking = true
		if is_on_floor():
			rotArm.global_position.y = ogArmPos.y
		
	elif direction and (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and sprint != true and slide != true and crouch == true:
		charCollide.disabled = true
		crouchCollide.disabled = false
		slideCollide.disabled = true
		
		playerAnim.play("crouch")
		velocity.x = direction * CROUCHSPEED
		walking = true
		if is_on_floor():
			rotArm.global_position.y = crouchPos.get_global_position().y
	
	elif direction and sprint == true and slide == false:
		charCollide.disabled = false
		crouchCollide.disabled = true
		slideCollide.disabled = true
		
		playerAnim.play("walk")
		velocity.x = direction * SPRINTSPEED
		walking = true
		if is_on_floor():
			rotArm.global_position.y = ogArmPos.y
			
	elif direction and slide == true:
		charCollide.disabled = true
		crouchCollide.disabled = true
		slideCollide.disabled = false
		
		playerAnim.play("walk")
		velocity.x = direction * SLIDESPEED
		walking = true
		if is_on_floor():
			rotArm.global_position.y = ogArmPos.y
		
	else:
		if crouch != true:
			playerAnim.play("idle")
			charCollide.disabled = false
			crouchCollide.disabled = true
			slideCollide.disabled = true
		slideTimeout = false
		slide = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walking = false
	move_and_slide()
	
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	
	crosshair.global_position = get_global_mouse_position()
	crossCollider.global_position = get_global_mouse_position()
	
	if crosshairMove != false:
		gunArm.look_at(crosshair.get_global_position())
		rotArm.look_at(rotPoint.get_global_position())
	
	if get_global_mouse_position().x < self.get_global_position().x:
		playerBody.set_scale(Vector2(-1,1))
		attack.bulletpos.set_scale(Vector2(1,-1))
		flipped = true
	else:
		playerBody.set_scale(Vector2(1,1))
		attack.bulletpos.set_scale(Vector2(1,1))
		flipped = false
	
	if Input.is_action_just_pressed("fire"):
		attack.fire()
		rotPoint.position = Vector2(recoilPoint.get_position().x,  rotPoint.get_position().y)
		recoil = true
	if Input.is_action_just_pressed("reload"):
		attack.reload()
	if attack.is_playing() == false:
		attack.play("default")
	
	if recoil == true:
		if round(rotPoint.get_position().x) >= round(rotPointOG.get_position().x) and round(rotPoint.get_position().x) >= 0:
			recoil = false
		rotPoint.position = Vector2(rotPoint.get_position().x + 0.5,  rotPoint.get_position().y)

func _on_cross_collider_body_entered(body):
	if body.name == "player":
		crosshairMove = false

func _on_cross_collider_body_exited(body):
	if body.name == "player":
		crosshairMove = true

func _on_slide_timer_timeout():
	slideTimeout = true
	slideTimer.stop()
