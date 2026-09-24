extends Area2D

@onready var animator = $AnimatedSprite2D
@onready var infoLabelBox = $infoLabelSprite
@onready var infoLabelTitle = $infoLabelSprite/Control/Title
@onready var infoLabelInfo = $infoLabelSprite/Control/Info

@export var coinName = "debug"
@export var coinDesc = "Debug Coin!"
@export var value = 0
@export var rarity = 0

var rarityNames = {0:"Common", 1:"Uncommon", 2:"Rare", 3:"Epic", 4:"Legendary", 5:"Mythical", 6:"Unique"}
var sides = {0:"Heads", 1:"Tails"}
var side = 0
var hovered = false
var clicked = false
var buttonClicked = false

func _ready():
	infoLabelTitle.text = coinName
	infoLabelInfo.text = coinDesc + "\nValue: " +  str(value) + "\nRarity: " + str(rarityNames.get(rarity)) + "\nSide: " + str(sides.get(side))

func flip():
	if animator.frame == 0:
		animator.frame = 1
		side = 1
	elif animator.frame == 1:
		animator.frame = 0
		side = 0

func _physics_process(delta):
	infoLabelTitle.text = coinName
	infoLabelInfo.text = coinDesc + "\nValue: " +  str(value) + "\nRarity: " + str(rarityNames.get(rarity)) + "\nSide: " + str(sides.get(side))
	
	if hovered == false:
		if Input.is_action_just_pressed("leftClick") and clicked == false and buttonClicked == false:
			#print(hovered)
			clicked = true
			infoLabelBox.visible = false
	else:
		if Input.is_action_just_pressed("leftClick") and clicked == false: 
			#print(hovered)
			clicked = true
			infoLabelBox.visible = true
	
	clicked = false
	buttonClicked = false

func _on_flip_button_button_down():
	buttonClicked = true
	flip()
