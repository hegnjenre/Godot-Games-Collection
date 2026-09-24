extends "res://scenes/modifier.gd"

func activate(block):
	if block.name != "enemyBlock":
		block.extraSpeed += 0.025
		block.wallCollided = false
