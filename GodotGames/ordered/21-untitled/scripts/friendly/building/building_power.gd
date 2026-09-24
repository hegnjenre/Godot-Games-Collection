extends "res://scripts/friendly/building/building_super.gd"

var powerAdded = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if placed:
		if sprite.animation != "activated":
			sprite.play("activated")
		if !activated and powerAdded:
			Global.decrease_power() # decrease total power by 5
			powerAdded = false
		elif activated && !powerAdded:
			Global.increase_power() # increase total power by 5
			powerAdded = true
