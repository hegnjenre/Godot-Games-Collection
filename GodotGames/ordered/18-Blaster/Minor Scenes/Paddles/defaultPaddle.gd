extends CharacterBody2D

@export var paddleSpeed = 5
@onready var yPosOrigin = get_global_position().y
@onready var cooldown = $cooldown
var stop = false
var ballCollide = false

func _process(_delta):
	global_position.y = yPosOrigin
	
	if Global.is_arena() and stop == false:
		if Input.is_action_pressed("left"):
			velocity = Vector2(-1,0)
		elif Input.is_action_pressed("right"):
			velocity = Vector2(1,0)
		else:
			velocity = Vector2(0,0)
	else:
		velocity = Vector2(0,0)
	
	var collision = move_and_collide((velocity * paddleSpeed))
	if (collision != null and collision.get_collider().is_in_group("balls")) or (ballCollide == true): 
		if collision != null and collision.get_collider().is_in_group("balls"):
			collision.get_collider().paddleCollide = true
			collision.get_collider().velocity.bounce(collision.get_normal())
		if stop == false:
			velocity = Vector2(0,0)
			stop = true
			cooldown.start()

func powerup(type):
	if type == "ET":
		var timer = get_parent().timer
		var timeAdd = get_parent().addOpaque()
		var curTime = timer.get_time_left()
		timer.stop()                        # reset timer with current time and extra
		timer.set_wait_time(curTime + 10)
		timer.start()
	elif type == "EB":
		Global.set_balls((Global.get_balls() + 1))
	elif type == "WP":
		pass
	elif type == "G":
		Global.add_gold(1)


func _on_cooldown_timeout():
	stop = false
	ballCollide = false
