extends Node2D

@export var height = 0.0
#no width for now

@onready var mesh = $MeshInstance2D
@onready var meshObject = mesh.mesh
@onready var area = $MeshInstance2D/Area2D
@onready var areaCollider = $MeshInstance2D/Area2D/CollisionShape2D
@onready var areaColliderObject = areaCollider.shape

func _ready():
	pass

func _process(delta):
	height = clampf(height, 0.01, 999) #change to be min and max ocean depth obvs
	var heightOffset = -(height/2)
	meshObject.size = Vector2(50, height)
	meshObject.center_offset = Vector3(0, heightOffset, 0)
	areaColliderObject.size = Vector2(50, height)
	areaCollider.position = Vector2(0, heightOffset)

#buoyancy formula = (water density)*area*gravity
