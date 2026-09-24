extends Control

var preChannel = preload("res://scenes/friendly/building/resource_channel.tscn")

var prePowerSiphon = preload("res://scenes/friendly/building/building_power.tscn")
var preDump = preload("res://scenes/friendly/building/building_dump.tscn")
var preSteelMine = preload("res://scenes/friendly/building/building_steel_plate.tscn")
var preButton = preload("res://scenes/UI/building_button.tscn")

var buildingList = {prePowerSiphon : preload("res://sprites/friendly/buildings/power siphon.png"),
 					preDump : preload("res://sprites/friendly/buildings/dump1.png"),
 					preSteelMine : preload("res://sprites/friendly/buildings/steel building base.png")}

@onready var listContainer = $VBoxContainer

var selected = null
var selectedButton = null
var hovered = null
var placed = false
var channeling = false
var channeled = false
var newChannelStep = 0
var newChannelStart = null
var newChannelEnd = null

var mousePos = Vector2()
var mouseTile = Vector2()

func _unhandled_input(event):
	if selected != null && !placed:
		mousePos = get_global_mouse_position()
		var mouseChunkLocation = Global.get_current_mouse_chunk()
		if mouseChunkLocation != null:
			var chunkTiles = mouseChunkLocation.get_node("tiles")
			mouseTile = chunkTiles.map_to_local(chunkTiles.local_to_map(mousePos))
			if selected.visible != true:
				selected.visible = true
			#print("Tile: " + mouseChunkLocation.name + " " + str(mouseTile))

func unload_buttons():
	for bKey in buildingList.keys():
		var newButton = preButton.instantiate()
		listContainer.add_child(newButton)
		newButton.icon = buildingList.get(bKey)
		var newBuildingPre = bKey
		newButton.building = newBuildingPre
		newButton.buildController = self

func place_building() -> bool:
	selected.set_global_position(mouseTile)
	if Input.is_action_just_pressed("leftClick"):
		selected.set_global_position(mouseTile)
		selected.placed = true
		return true
	if Input.is_action_just_pressed("rightClick"):
		selected.queue_free()
		selected = null
		selectedButton = null
	return false

func place_channel() -> bool:
	## show buildings eligibility red/green
	## select start of channel
	if Input.is_action_just_pressed("rightClick"):
		newChannelStart = null
		newChannelEnd = null
		newChannelStep = 0
		return true
	if newChannelStep == 0:
		if Input.is_action_just_pressed("leftClick"):
			if hovered != null && hovered.outputChannel == null:
				newChannelStart = hovered
				#print("Start Point: " + hovered.name)
				newChannelStep += 1
			elif hovered != null && hovered.outputChannel != null:
				hovered.outputChannel.killChannel()
				newChannelStart = hovered
				#print("Start Point: " + hovered.name)
				newChannelStep += 1
	## select end of channel
	elif newChannelStep == 1:
		if Input.is_action_just_pressed("leftClick"):
			if hovered != null:
				newChannelEnd = hovered
				#print("End Point: " + hovered.name)
				newChannelStep += 1
	## create channel and a star pathing visual of channel
	else:
		var newChannel = preChannel.instantiate()
		newChannel.fromNode = newChannelStart
		newChannel.toNodes.append(newChannelEnd)
		newChannel.resource = newChannelStart.outputResource
		#newChannel.change_grid_size(newChannelStart.get_global_position(), newChannelEnd.get_global_position())
		Global.get_world_root().add_child(newChannel)
		newChannel.name = "ResChannel" + str(Global.get_c_id())
		newChannel.build_channel(newChannelStart, newChannelEnd)
		newChannelStart = null
		newChannelEnd = null
		newChannelStep = 0
		return true
	return false

func _ready() -> void:
	unload_buttons()

func _process(_delta: float) -> void:
	## place new building ## 
	if selected != null && !placed:
		placed = place_building()
	elif placed:
		selected = null
		selectedButton = null
		placed = false
	else:
		pass
		#print(mouseTile)
	## place new channel ##
	if channeling and !channeled:
		channeled = place_channel()
	elif channeled:
		channeled = false
		channeling = false

func _on_button_pressed() -> void:
	if selected == null:
		channeling = true
