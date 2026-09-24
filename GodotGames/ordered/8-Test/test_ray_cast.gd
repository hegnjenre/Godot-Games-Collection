extends RayCast3D

@export_group("Spring Properties")
@export var spring_rest_length := 0.7
@export var spring_stiffness := 70.0
@export var spring_damper := 4.0

@onready var car := $".." as RigidBody3D

var spring_curr_length := 0.0
var tire_world_velocity := Vector3.ZERO


func _ready() -> void:
	# in Godot 3.x this property is called `cast_to`
	target_position = Vector3.DOWN * spring_rest_length


func _physics_process(delta: float) -> void:
	tire_world_velocity = get_point_velocity(global_position)
	
	if is_colliding():
		var force_point := get_collision_point() - car.global_position
		car.apply_force(Vector3.UP * get_spring_force(), force_point)


func get_spring_force() -> Vector3:
	var spring_dir := get_collision_normal()
	
	spring_curr_length = get_collision_point().distance_to(global_position)
	spring_curr_length = clampf(spring_curr_length, 0.0, spring_rest_length)
	
	var spring_offset := spring_rest_length - spring_curr_length
	var spring_velocity := spring_dir.dot(tire_world_velocity)
	var spring_force := (spring_offset * spring_stiffness) - (spring_velocity * spring_damper)
	
	return spring_dir * spring_force


# prefix `gs_` stands for `global space`
func get_point_velocity(gs_point: Vector3) -> Vector3:
	var linear_velocity := car.linear_velocity
	var angular_velocity := car.angular_velocity
	var gs_position := car.global_position
	
	print(linear_velocity + angular_velocity.cross(gs_point - gs_position))
	
	return linear_velocity + angular_velocity.cross(gs_point - gs_position)
