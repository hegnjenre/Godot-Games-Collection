extends Node2D

@onready var player = $playerMap
@onready var tilemap = $tiles

var prevLocNode = null
var locationNodeScene = preload("res://scenes/player/loc_node.tscn")
var clickedLocation = null
var locNodeTrue = false
var locNode = null
var clickable = true #can move locNode
var moving = false #is moving to loc

func _process(_delta):
	if locNodeTrue == true and locNode.location != null:
		var selectedLocation = locNode.location
		clickable = false
		if moving == true:
			player.updateNav()
			if selectedLocation.global_position.is_equal_approx(player.global_position): #resets things once reached the location
				moving = false
				locNodeTrue = false
				clickable = false
		selectedLocation.UIVisible()
		if selectedLocation.travel == true:
			updateTargetLocation(selectedLocation.global_position)
			selectedLocation.travel == false
			moving = true
		elif selectedLocation.info == true:
			selectedLocation.info == false
		elif selectedLocation.enter == true:
			updateTargetLocation(selectedLocation.global_position)
			selectedLocation.enter == false
			moving = true
			
			
	if Input.is_action_just_pressed("leftC") and clickable == true:
		clickedLocation = get_global_mouse_position()
		var clickedTile = tilemap.local_to_map(tilemap.get_local_mouse_position())
		var data = tilemap.get_cell_tile_data(0, clickedTile)
		if data.terrain < 2:
			if prevLocNode == null:
				locNode = locationNodeScene.instantiate()
				prevLocNode = locNode
				add_child(locNode)
				locNodeTrue = true
			elif prevLocNode != null:
				locNode = prevLocNode
			locNode.global_position = clickedLocation
		else: 
			print("impassable")

func updateTargetLocation(target):
	player.targetPosition = target
