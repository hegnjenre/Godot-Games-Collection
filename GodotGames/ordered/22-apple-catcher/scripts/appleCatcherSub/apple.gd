extends CharacterBody2D

@onready var timer = $Timer

var appleGravity = 0.3
var appleRot = 32
var fall = true
var controller = null

func _ready() -> void:
	appleRot = randi_range(-8, 8)
	if appleRot == 0:
		appleRot = 1

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("basket"):
		Global.add_point()
		queue_free()

func _process(_delta: float) -> void:
	if fall:
		velocity.y += (appleGravity * 9.8)
		rotation_degrees += appleRot
		move_and_slide()
	else:
		pass
