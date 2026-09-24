extends StaticBody3D

@export var connectedSystem:StaticBody3D = null
@export var liftHeight = 3

var open = false

func _physics_process(_delta):
	
	if connectedSystem.pressed == true:
		open = true
	
	if open == true and liftHeight > 0:
		self.global_position.y = self.get_global_position().y + 0.05
		liftHeight -= 0.05
	elif open == true and liftHeight <= 0:
		open = false
