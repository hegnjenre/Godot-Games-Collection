extends RigidBody2D

@onready var mesh = $MeshInstance2D
@onready var collide = $Area2D/CollisionShape2D

var in_water = false ## need to find a way to tell if yes or no
var waterSections = []
var lowest = Vector2(0,0)

func getLowestPoint(): ## wont work for big or non-symmetrical objects
	var meshArrays = mesh.mesh.surface_get_arrays(0)
	var vertices = meshArrays[Mesh.ARRAY_VERTEX]
	var min = 9999
	for vert in vertices:
		if vert.y < min:
			min = vert.y
	return Vector2(0,min)


## OK idea is that to find the area beneath the wave we take the vertex positions of each object, convert them to global and
## then compare them to find the first y coordinate in the object below to the highest y coordinate of the wave, we then
## know that every other vertex below that must be below the wave too. With this, we take 


func _process(_delta):
	if in_water:
		for sect in waterSections:
			buoyant(sect)

func buoyant(section):
	var buoyantImpulseForce = Vector2(1, -(Global.waterDensity*0.2*9.8))
	apply_force(buoyantImpulseForce, getLowestPoint())


func _on_area_2d_area_entered(area):
	var body = area.get_parent().get_parent()
	if body.is_in_group("water"):
		print("entered")
		waterSections.append(body)
		if(in_water == false):
			in_water = true

func _on_area_2d_area_exited(area):
	var body = area.get_parent().get_parent()
	if body.is_in_group("water"):
		print("exited")
		waterSections.erase(body)
		if(in_water == true and waterSections.is_empty()):
			in_water = false
