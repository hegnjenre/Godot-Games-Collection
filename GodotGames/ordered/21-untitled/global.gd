extends Node

@onready var trueRoot = get_node("../")
@onready var worldRoot = trueRoot.get_node("debug") ## THIS SHOULD BE WHATEVER THE ACTUAL WORLD ROOT NAME IS

## LIST OF RESOURCES ASSIGNED TO NUMBER:
## -2   NULL
## -1   ANY
## 0    GROUND / NONE
## 1    POWER
## 2    STEEL PLATE
## 3    COPPER PLATE
## 4    NUTS BOLTS
## 5    MICROCHIP
## 6    AMMO
## 7    UPGRADE

var player = null
var object_ids = {}
var object_num = 0
var path_grid = null
var currentChunk = null
var currentMouseChunk = null
var uiControl = null
var buildingID = -1
var channelID = -1

## Player Resources
var player_resources = {1 : 0,   #power
						2 : 0,   #steel_plate
						3 : 0,   #copper_plate
						4 : 0,   #nuts_bolts
						5 : 0,   #microchip
						6 : 0,   #ammo
						7 : 0}  #upgrade

var resource_key = {1 : "power",
					2 : "steel_plate",
					3 : "copper_plate",
					4 : "nuts_bolts",
					5 : "microchip",
					6 : "ammo",
					7 : "upgrade"}

func add_obj(obj):
	object_ids.get_or_add(object_num, obj)
	object_num += 1
	return (object_num-1) ## object also knows id

func get_root():
	return trueRoot

func get_world_root():
	return worldRoot

func get_b_id():
	buildingID += 1
	return buildingID

func get_c_id():
	channelID += 1
	return channelID

func increase_power():
	player_resources.set(1, (player_resources.get(1) + 5))

func decrease_power():
	player_resources.set(1, (player_resources.get(1) - 5))
	
func get_current_power():
	return player_resources.get(1)

func take_power():
	player_resources.set(1, (player_resources.get(1) - 1 ))

func return_power():
	player_resources.set(1, (player_resources.get(1) + 1 ))

func add_resource(resource):
	player_resources.set(resource, (player_resources.get(resource) + 1))

func get_resource(resource):
	return player_resources.get(resource)

func print_resources():
	print(player_resources)

func initialize_resources_ui(controller):
	for rKey in player_resources.keys():
		controller.create_new_textbox("resource", str(player_resources.get(rKey)), (str(resource_key.get(rKey)) + "_UI"))

func set_path_grid(obj):
	path_grid = obj

func get_path_grid():
	return path_grid

func get_map():
	return object_ids.get(0)

func set_ui_controller(obj):
	uiControl = obj

func get_ui_controller():
	return uiControl

func set_player(obj):
	player = obj

func get_player():
	return player

func get_player_current_health():
	return player.health

func get_player_max_health():
	return player.maxHealth

func set_current_chunk(chunk):
	currentChunk = chunk

func get_current_chunk():
	return currentChunk

func clear_current_chunk():
	currentChunk = null

func set_current_mouse_chunk(chunk):
	currentMouseChunk = chunk

func get_current_mouse_chunk():
	return currentMouseChunk

func clear_current_mouse_chunk():
	currentMouseChunk = null
