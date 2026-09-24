extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var intPressed = false

@onready var root = get_tree().get_root().get_child(0)
@onready var camRig = $camRig
@onready var cam = $camRig/Camera3D
@onready var intRay = $camRig/Camera3D/interactRay
@onready var flashPoint = $camRig/Camera3D/flashPoint

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("esc"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camRig.rotate_y(-event.relative.x * 0.002) #if 0.02 is max then 0.002 is 10% sensitivity
			cam.rotate_x(-event.relative.y * 0.002)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-75), deg_to_rad(75))

func _physics_process(delta):
	var collide = intRay.get_collider()
	intPressed = false
	if collide != null:
		if collide.is_in_group("noInteract") != true:
			if Input.is_action_just_pressed("interact") and collide.is_in_group("door") == true and intPressed != true:
				collide.get_parent().get_parent().open()
	
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
