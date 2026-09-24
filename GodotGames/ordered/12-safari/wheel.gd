extends RayCast3D

@export var strength = 400.0         ## for now, strength should be 10 times the weight, and damp should be weight-10.
@export var damp = 30.0              ## obviously incorrect, will be closer to logarithmic
@export var restingDistance = 0.4
@export var frontWheel = false
var wheelSize = 0.5

@onready var wheelMesh = $carWheel

func _process(_delta):
	pass
