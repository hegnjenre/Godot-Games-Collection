extends StaticBody2D

var ball = preload("res://Minor Scenes/Balls/defaultBall.tscn")

@export var ballNum = 3

var currentBall = null

func _ready():
	Global.set_balls(ballNum)
	rotation_degrees = -24

func _process(delta):
	#print(transform.x)
	var mousePos = get_global_mouse_position()
	if Global.is_arena():
		look_at(mousePos)
		rotation_degrees = clamp(rotation_degrees, -126, 5)
	
	if Global.get_balls() <= 0 and currentBall == null:
		get_parent().timer.stop()
		get_parent().timer.set_wait_time(0.00000000001) #scuffed solution to ending day when out of balls
		get_parent().timer.start()
	
	if Global.is_arena() and Input.is_action_just_pressed("leftClick"):
		ballNum = Global.get_balls()
		if ballNum >= 1 and currentBall == null:
			ballNum -= 1
			Global.set_balls(ballNum)
			var newBall = ball.instantiate()
			get_parent().add_child(newBall)
			currentBall = newBall
			newBall.global_position = $ballSpawn.global_position
			newBall.velocity = Vector2(transform.x * 3)
