extends RigidBody3D

@onready var rayFL = get_node("../floatCastFL")
@onready var rayBL = get_node("../floatCastBL")
@onready var rayFR = get_node("../floatCastFR")
@onready var rayBR = get_node("../floatCastBR")

@onready var rays = [rayFL, rayBL, rayFR, rayBR]
@onready var floorRay = $floorCast

@onready var origin = get_global_position()
var floatForce = 1000
var interacting = false
var interactable = false
var is_floating = false

func _physics_process(delta):
	#print("intable: " + str(interactable))
	#print("inting: " + str(interacting))
	#print("isFloat: " + str(is_floating))
	if is_on_floor():
		interactable = true
		origin = get_global_position()
	else:
		interactable = false
	
	if interactable == true or is_floating == true:
		if interacting == true:
			is_floating = true
			floating(origin, floatForce, delta)
		elif interacting == false and is_floating == true:
			interactable = false
			is_floating = false
			apply_force(-(Vector3(0, 9.8, 0)), Vector3.DOWN)

func is_on_floor():
	var success = false
	floorRay.force_raycast_update()
	if floorRay.is_colliding():
		var collide = floorRay.get_collision_point()
		#print("\nColliding: " + str(floorRay.get_collider()))
		#print("collidePos: " + str(collide))
		#print("ray: " + str(floorRay.global_transform.origin))
		if collide == floorRay.global_transform.origin:
			success = true
		else:
			success = false
		
	return success

func floating(origin, floatForce, delta):
	for ray in rays:
		ray.force_raycast_update()
		if ray.is_colliding():
			var collide = ray.get_collision_point()
			var dist = origin.y - ray.global_transform.origin.y
			if dist == 0:
				dist = 0.2
			apply_force(Vector3.UP * (dist) * floatForce * delta, ray.global_transform.origin - self.global_transform.origin)
	

