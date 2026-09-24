extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var grabbed = false
var intPressed = false
var currentViewModel = null

var grabbedObj = null

@onready var root = get_tree().get_root().get_child(0)
@onready var camRig = $camRig
@onready var cam = $camRig/Camera3D
@onready var intRay = $camRig/Camera3D/interactRay
@onready var intPoint = $UI/intPointer
@onready var gPoint = $camRig/Camera3D/grabPoint
@onready var weaponPoint = $camRig/Camera3D/weaponPoint

func _ready():
	if weaponPoint.get_child_count() > 0: #temporary while no unarmed viewmodel
		currentViewModel = weaponPoint.get_child(0)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camRig.rotate_y(-event.relative.x * 0.002) #20% of 0.01, if 0.02 is max then 0.002 is 10% sensitivity
			cam.rotate_x(-event.relative.y * 0.002)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-75), deg_to_rad(75))

func interact(action):
	if action == "pickup":
		grabbed = true
		grabbedObj.set_collision_layer_value(1, false)
		grabbedObj.set_collision_layer_value(3, true)
		grabbedObj.set_collision_mask_value(1, false)
		grabbedObj.set_collision_mask_value(3, true)
	elif action == "drop":
		grabbedObj.set_collision_layer_value(1, true)
		grabbedObj.set_collision_layer_value(3, false)
		grabbedObj.set_collision_mask_value(1, true)
		grabbedObj.set_collision_mask_value(3, false)
		grabbedObj.reparent(root)
		grabbedObj.lock_rotation = false
		grabbed = false

func moveObj(object, delta):
	object.reparent(camRig)
	object.lock_rotation = true
	var objOrigin = object.global_transform.origin
	var gPointOrigin = gPoint.global_transform.origin
	object.rotation = cam.rotation
	object.set_linear_velocity((gPointOrigin-objOrigin)*8.5)

func _physics_process(delta):
	var collide = intRay.get_collider()
	intPressed = false
	if collide != null:
		if collide.is_in_group("noInteract") != true:
			intPoint.visible = true
			if Input.is_action_just_pressed("interact") and collide.is_in_group("physObj") == true and intPressed != true and grabbed == false:
				intPressed = true
				grabbedObj = collide
				interact("pickup")
			elif Input.is_action_just_pressed("interact") and collide.is_in_group("door") == true and intPressed != true:
				collide.get_parent().get_parent().open()
		else:
			intPoint.visible = false
	else:
		intPoint.visible = false
		
	if Input.is_action_just_pressed("interact") and grabbed == true and intPressed != true:
		intPressed = true
		interact("drop")
		grabbedObj = null
	
	if Input.is_action_just_pressed("leftClick"):
		currentViewModel.get_node("animPlayer").play("sliceAnim")
	
	if grabbed == true:
		moveObj(grabbedObj, delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (camRig.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
