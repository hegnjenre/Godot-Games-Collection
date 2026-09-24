extends "res://weapon.gd"


func _ready():
	type = "weapon"
	attacks = ["Slash"]
	attackAnims = {"Slash":["SlashAnim"]}
	damageDice = ["d6", "d6", "d6"]
	itemName = "DebugSword"
	cost = 999
	
