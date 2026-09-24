extends Area2D

@onready var label = $Label
var playerChar = Global.get_playerChar()

var on = false
var enabled = true

func _process(delta):
	if playerChar == null:
		playerChar = Global.get_playerChar()
	
	if on == true and enabled == true:
		label.visible = true
		if Input.is_action_just_pressed("interact"):
			doInteract()
			label.visible = false
	else:
		label.visible = false

func _on_body_entered(body):
	if body.is_in_group("char"):
		on = true

func _on_body_exited(body):
	if body.is_in_group("char"):
		on = false

func doInteract():
	pass
