extends Node2D

@onready var cam = $Camera2D
@onready var appleCatchSceneView = $SubViewportContainer/SubViewport
@onready var appleCatchSceneContainer = $SubViewportContainer

var zoom = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter") && !zoom:
		appleCatchSceneContainer.set_global_position(Vector2(0,0))
		appleCatchSceneView.size = Vector2(1280,720)
		appleCatchSceneView.size_2d_override = Vector2(0,0)
		appleCatchSceneView.size_2d_override_stretch = false
		cam.zoom = Vector2(0.9,0.9)
		cam.set_global_position(Vector2(640,360))
		zoom = true
	elif Input.is_action_just_pressed("enter") && zoom:
		appleCatchSceneContainer.set_global_position(Vector2(268,100))
		appleCatchSceneView.size = Vector2(640,360)
		appleCatchSceneView.size_2d_override = Vector2(1280, 720)
		appleCatchSceneView.size_2d_override_stretch = true
		cam.zoom = Vector2(1,1)
		cam.set_global_position(Vector2(576,324))
		zoom = false
