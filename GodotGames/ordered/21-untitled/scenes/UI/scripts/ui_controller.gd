extends Control

var textBoxRes = preload("res://scenes/UI/text_box.tscn")

@export var debug = false

@onready var topBar = $ControlTop
@onready var resBar = $ControlTop/Resources
@onready var buildView = $buildingView

@onready var debugH = $ControlTop/debugHealth

@onready var placementList = {"top" : topBar,
							  "resource" : resBar}

var resourceIdx = 1
var resource_ui = {1 : null,   #power
				   2 : null,   #steel_plate
				   3 : null,   #copper_plate
				   4 : null,   #nuts_bolts
				   5 : null,   #microchip
				   6 : null,   #ammo
				   7 : null}  #upgrade

var buildMode = false

func create_new_textbox(placement:String, text:String, boxName:String = "",  width:int = -1, height:int = -1):
	if placementList.has(placement):
		var container = placementList.get(placement)
		var newBox = textBoxRes.instantiate()
		container.add_child(newBox)
		if boxName != "":
			newBox.name = boxName
		newBox.get_node("Label").set_text(text)
		newBox.get_node("Label").force_update_transform()
		await get_tree().process_frame
		## since force update transform is only completed at the end of the frame, we force the game to wait until then to continue
		if width != -1 && height != -1:
			newBox.get_node("Panel").size = Vector2(width, height)
		else:
			newBox.get_node("Panel").size = newBox.get_node("Label").size
			newBox.custom_minimum_size = newBox.get_node("Label").size
		if placement == "resource":
			resource_ui.set(resourceIdx, newBox)
			resourceIdx += 1

func _ready() -> void:
	Global.set_ui_controller(self)
	if debug:
		$ControlDebug.visible = true

func _process(_delta: float) -> void:
	debugH.text = (str(Global.get_player_current_health()) + " / " + str(Global.get_player_max_health())) 
	for rKey in resource_ui:
		if resource_ui.get(rKey) != null:
			resource_ui.get(rKey).get_node("Label").text = str(Global.get_resource(rKey))

func _on_button_pressed() -> void: ## debug build view
	if buildView.visible == true:
		buildView.visible = false
		topBar.visible = true
		buildMode = false
	else:
		buildView.visible = true
		topBar.visible = false
		buildMode = true
