extends Node2D

var shopScene = preload("res://Scenes/shop_scene.tscn")

@onready var root = get_tree().root
@onready var currentScene = get_tree().root.get_child(1)
@onready var focusPoint = $currentFocusPoint.get_global_position()
@onready var rightArrow = $UI/rightArrow
@onready var leftArrow = $UI/leftArrow

var right = false
var left = false
var focusArray = []
var focused = null
var focusIndex = 0

func _on_right_arrow_pressed():
	right = true

func _on_left_arrow_pressed():
	left = true

func _physics_process(_delta):
	if focused == null:
		rightArrow.visible = false
		leftArrow.visible = false
	else:
		rightArrow.visible = true
		leftArrow.visible = true
	
	if right == true:
		focused.visible = false
		if focusIndex != focusArray.size()-1:
			focusIndex += 1
		else:
			focusIndex = 0
		focused = focusArray[focusIndex]
		focused.visible = true
		#print(str(focusIndex) + ": " + str(focused))
		right = false
	elif left == true:
		focused.visible = false
		if focusIndex != 0:
			focusIndex -= 1
		else:
			focusIndex = focusArray.size()-1
		focused = focusArray[focusIndex]
		focused.visible = true
		#print(str(focusIndex) + ": " + str(focused))
		left = false

func _on_open_shop_pressed():
	print(currentScene)
	var newScene = shopScene.instantiate()
	root.add_child(newScene)
	currentScene.queue_free()
