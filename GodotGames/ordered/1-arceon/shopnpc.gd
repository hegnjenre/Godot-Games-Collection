extends "res://npc.gd"

@onready var shopFront = $shopFront
@onready var shopCam = $shopFront/shopCam
@onready var prevCam = get_viewport().get_camera_3d()

var shopOpen = false
var camSw = false

func _ready():
	npcType = "sell"
	accessDFile(dialogueRes)
	infoCon.visible = false

func _process(_delta):
	if shopOpen == true:
		shopFront.visible = true
	if shopOpen == true and camSw != true:
		prevCam = get_viewport().get_camera_3d()
		shopCam.current = true
		camSw = true
	if player.shopExit == true:
		prevCam.current = true
		shopOpen = false
		shopFront.visible = false
		player.shopExitButton.visible = false
		camSw = false
		player.controllable = true
		player.shopExit = false
		
	if player.controllable == true:
		if Input.is_action_just_pressed("interact") and display == false and interactable == true and convoStart == false:
			infoCon.visible = true
			display = true
			convoStart = true
		elif interactable == false:
			infoCon.visible = false
			convoStart = false
			index = 0
		
		if convoStart == true and Input.is_action_just_pressed("interact") and npcType == "sell":
			if index <= len(textArray)-1:
				var line = textArray[index].split("_")
				title.text = line[0]
				info.text = line[1]
				index += 1
			else:
				convoStart = false 
				index = 0
				infoCon.visible = false
				player.shopExit = false
				display = false
				shopOpen = true
				shopFront.activated = true
				player.shopExitButton.visible = true
				player.controllable = false
