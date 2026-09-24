extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.name != "ball":
		pass
	else:
		print("Win")
		body.freeze = true
		body.set_global_position(self.get_global_position())
		body.axis_lock_linear_x = true
		body.axis_lock_linear_y = true

