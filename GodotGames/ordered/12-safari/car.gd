extends RigidBody3D

var car_start = true
var acceleration_input = 0.0
var turn_input = 0.0
var on_ground = false
var turn = 0.0

@export var topSpeed = 80.0
@export var naturalDecel = 55.0
@export var acceleration = 200.0
@export var accelerationCurve : Curve

@onready var wheels = $suspension.get_children() #array of wheels

func _unhandled_input(event):
	if event.is_action_pressed("forward"):
		acceleration_input = 1.0
	elif event.is_action_released("forward"):
		acceleration_input = 0.0
	
	if event.is_action_pressed("reverse"):
		acceleration_input = -1.1
	elif event.is_action_released("reverse"):
		acceleration_input = 0.0
	
	if event.is_action_pressed("right"):
		turn_input = -1.0
	elif event.is_action_released("right"):
		turn_input = 0.0
	
	if event.is_action_pressed("left"):
		turn_input = 1.0
	elif event.is_action_released("left"):
		turn_input = 0.0

func get_point_velocity(point):
	return (linear_velocity + angular_velocity.cross(point-global_position))

func wheelAccelerate(wheel):
	var forward = -wheel.global_transform.basis.z
	var currentSpeed = forward.dot(linear_velocity)
	wheel.wheelMesh.rotate_x(-currentSpeed * get_process_delta_time() * 2 * PI * wheel.wheelSize)
	
	if wheel.is_colliding():
		#print(str(currentSpeed))
		var point = wheel.wheelMesh.global_position
		var forcePosition = point - global_position
		
		if wheel.frontWheel == true and acceleration_input:
			var accelRatio = currentSpeed / topSpeed
			var curveAdjust = accelerationCurve.sample_baked(accelRatio)
			var forceVector = acceleration * forward * acceleration_input * curveAdjust#
			apply_force(forceVector, forcePosition)
		elif abs(currentSpeed) > 0.02 and !acceleration_input: ## checks if any speed in either direction so it comes to a stop
			var nat_forceVector = global_transform.basis.z * naturalDecel * signf(currentSpeed) 
			## signf returns sign bit, so checks if speed is neg or pos
			apply_force(nat_forceVector, forcePosition)

func wheelTurn(wheel):
	if wheel.frontWheel == true:
		if abs(turn_input) > 0.0:
			turn = 2
			if int(rad_to_deg(wheel.wheelMesh.rotation.y)) < 40:
				wheel.wheelMesh.rotate_y(deg_to_rad(turn) * turn_input)
				print(int(rad_to_deg(wheel.wheelMesh.rotation.y)))
		else:
			turn = -2
			if int(rad_to_deg(wheel.wheelMesh.rotation.y)) > 0:
				wheel.wheelMesh.rotate_y(deg_to_rad(turn))
				print(int(rad_to_deg(wheel.wheelMesh.rotation.y)))
			else:
				wheel.wheelMesh.rotation.y = 0.0
				print(str(wheel.wheelMesh.rotation.y))

func _process(_delta):
	on_ground = false
	if car_start == true:
		for wheel in wheels:
			if wheel.is_colliding:
				on_ground = true
			calcSuspension(wheel)
			wheelAccelerate(wheel)
			wheelTurn(wheel)
			
	if on_ground:
		center_of_mass = Vector3.ZERO
	else:
		center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
		center_of_mass = Vector3.DOWN * 0.5

func calcSuspension(wheel):
		wheel.force_raycast_update()
		if wheel.is_colliding():
			wheel.target_position.y = -(wheel.restingDistance + wheel.wheelSize + 0.1)
			var collide = wheel.get_collider()
			var point = wheel.get_collision_point()
			var UP = wheel.global_transform.basis.y
			var LENGTH = wheel.global_position.distance_to(point) - wheel.wheelSize
			var OFFSET = wheel.restingDistance - LENGTH ## calculate how far the wheel 
														## is from its rest position
			
			wheel.wheelMesh.position.y = -LENGTH
			
			var pointVel = get_point_velocity(point)
			var relativeVel = UP.dot(pointVel)
			var dampForce = wheel.damp * relativeVel
			
			var suspensionForce = wheel.strength * OFFSET ## force is the strength times the distance from rest
			var forceVector = (suspensionForce - dampForce) * wheel.get_collision_normal() ## apply force in direction upward from wheel
			point = wheel.wheelMesh.global_position
			var forcePosition = point - global_position ## point where the force will be applied
			
			apply_force(forceVector, forcePosition)
