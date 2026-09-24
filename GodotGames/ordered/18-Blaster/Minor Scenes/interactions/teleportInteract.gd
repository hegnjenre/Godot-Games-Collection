extends "res://Minor Scenes/interactScript.gd"

@export var teleLocation = Vector2(0,0)

func doInteract():
	playerChar.set_global_position(teleLocation)
	playerChar.can_move = false
	playerChar.in_chair = true
