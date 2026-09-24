extends Node2D

var applePre = preload("res://scenes/appleCatcherSub/apple.tscn")

var drop = true
var gravityRatio = 0.3
var on = false
var id = 0
var reset = true

@onready var timer = $Timer
@onready var gravChangeTimer = $gravChanger
@onready var apples = $apples

func _process(_delta: float) -> void:
	if on:
		if !reset:
			for apple in apples.get_children():
				apple.fall = true
				apple.timer.set_paused(false)
			reset = true
		if drop:
			var randx = randi_range(48, 1232)
			var randy = randi_range(-128, -256)
			var newApple = applePre.instantiate()
			apples.add_child(newApple)
			newApple.set_global_position(Vector2(randx, randy))
			drop = false
			newApple.appleGravity = gravityRatio
			newApple.controller = self
			id += 1
	else:
		if reset:
			reset = false
			for apple in apples.get_children():
				apple.fall = false
				apple.timer.set_paused(true)
				

func _on_timer_timeout() -> void:
	drop = true

func _on_grav_changer_timeout() -> void:
	gravityRatio += 0.05
	gravChangeTimer.wait_time += 5
