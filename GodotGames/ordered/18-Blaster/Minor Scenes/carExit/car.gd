extends CharacterBody2D

@onready var timer = $carTime
@onready var body = $carSprite
@onready var carInteract = $carinteract


var started = false
var day_end = false

func _process(_delta):
	if Global.is_end_of_day() and day_end == false:
		open_car()
		day_end = true
	
	if body.get_animation() == "start" and body.is_playing() == false: # screw this just animate the car as one thing
		body.play("driving")
		started = true
	
	if started == true:
		var player = Global.get_playerChar()
		player.velocity = Vector2(24,0)
		velocity = Vector2(24,0)
		move_and_slide()
		player.move_and_slide()

func startCar():
	body.play("start")

func open_car():
	carInteract.enabled = true

func _on_car_time_timeout():
	startCar()

func _on_in_seat_body_entered(body):
	if body.is_in_group("char"):
		body.set_collision_layer_value(1, false)
		body.set_collision_mask_value(1, false)
		body.set_collision_layer_value(10, true)
		body.set_collision_mask_value(10, true)
		timer.start()
