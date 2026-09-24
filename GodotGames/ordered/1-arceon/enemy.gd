extends Node3D

@onready var home = get_node("..")
@onready var prevCam = get_viewport().get_camera_3d()

var playerBody = null

@export var health = 100
@export var stamina = 100
@export var resilience = 0.2

func _on_battle_start_area_body_entered(body):
	if body.name != "player":
		return
	elif body.name == "player" and body.attackable == true:
		pass
	
func _process(_delta):
	pass
