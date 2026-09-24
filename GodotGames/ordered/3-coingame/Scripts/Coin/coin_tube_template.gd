extends Area2D

@onready var currentScene = get_tree().root.get_child(1)
@onready var infoLabelBox = $infoLabelSprite
@onready var infoLabelTitle = $infoLabelSprite/Control/Title
@onready var infoLabelInfo = $infoLabelSprite/Control/Info
@onready var interface = currentScene.get_child(0)

@export var tubeName = "debug tube"
@export var tubeDesc = "Debug Coin Tube!"
@export var price = 0
@export var coinTypeArray = ["debug", "1Peuro"]
@export var coinCount = 10

var coinTypes = {"debug":preload("res://Scenes/Coins/coin_template.tscn"), "1Peuro":preload("res://Scenes/Coins/coin_1_peuro.tscn")}
var opened = false
var hovered = false
var clicked = false

func _ready():
	infoLabelTitle.text = tubeName
	infoLabelInfo.text = tubeDesc + "\nPrice: " +  str(price) + "\nCoin Types: " + str(coinTypeArray) + "\nAmount of Coins: " + str(coinCount)

func open():
	for i in range(0, coinCount):
		var randType = randi_range(0, coinTypeArray.size()-1)
		var newCoin = coinTypes.get(coinTypeArray[randType]).instantiate()
		currentScene.add_child(newCoin)
		if i != 0:
			newCoin.visible = false
			interface.focused = newCoin
		newCoin.name = newCoin.coinName
		newCoin.global_position = interface.focusPoint
		var randFlip = randi_range(0,1)
		if randFlip == 1:
			newCoin.flip()
		interface.focusArray.append(newCoin)
		PlayerCollection.collection.append(newCoin)
	print(PlayerCollection.collection)
	opened = true
	self.queue_free()#change this later when the interface is more complete, so it queue frees after it's done with not on click

func displayInfo():
	infoLabelBox.visible = true

func _physics_process(delta):
	if hovered == true:
		if Input.is_action_just_pressed("leftClick") and clicked == false:
			clicked = true
			open()
		clicked = false
		displayInfo()
