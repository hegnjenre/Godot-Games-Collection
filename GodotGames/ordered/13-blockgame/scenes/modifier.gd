extends Node2D

@export var type = "wall_hit"
@onready var smallImg = $modSmall
@onready var bigImg = $modBig

func _physics_process(_delta):
	if get_parent().name == "blockMods":
		var parentBlock = get_parent().get_parent()
		if type == "wall_hit":
			if parentBlock.wallCollided == true:
				parentBlock.wallCollided = false
				activate(parentBlock)
		if type == "enemy_hit":
			if parentBlock.enemyCollided == true:
				parentBlock.enemyCollided = false
				activate(parentBlock)

func activate(block):
	pass

func display_big():
	smallImg.visible = false
	bigImg.visible = true

func display_small():
	smallImg.visible = true
	bigImg.visible = false
