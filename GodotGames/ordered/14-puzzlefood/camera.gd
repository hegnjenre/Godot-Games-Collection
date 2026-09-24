extends Camera3D

var mouseCollide = null
var interactCollide = null

func _process(_delta):
	mouseCollide = mouseRay()
	interactCollide = interactRay()

func mouseRay():
	var mousePos = get_viewport().get_mouse_position()
	var rayLength = 10000
	var from = project_ray_origin(mousePos)
	var to = from + project_ray_normal(mousePos) * rayLength
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayQuery.collide_with_areas = true
	rayQuery.set_collision_mask(0b1000)       # sets collision mask to layer 4 works like bit mask: 0b000... 1000 <- 4 only
	var result = space.intersect_ray(rayQuery)
	return result

func interactRay():
	var mousePos = get_viewport().get_mouse_position()
	var rayLength = 10000
	var from = project_ray_origin(mousePos)
	var to = from + project_ray_normal(mousePos) * rayLength
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = from
	rayQuery.to = to
	rayQuery.collide_with_areas = false
	rayQuery.set_collision_mask(0b0001)
	var result = space.intersect_ray(rayQuery)
	return result

