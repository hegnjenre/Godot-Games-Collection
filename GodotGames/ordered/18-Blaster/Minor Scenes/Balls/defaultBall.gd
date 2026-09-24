extends CharacterBody2D

@export var boostSpeed = 0.4
@export var maxySpeed = 5
@export var maxxSpeed = 6

@onready var debugSpeed = $debugSpeed
@onready var ccTimer = $collisionCooldown

var falling = 0
var cc = false
var paddleCollide = true

func _process(_delta):
	debugSpeed.text = str(velocity)
	if Global.is_arena():
		var collision = move_and_collide(velocity)
		if collision != null and cc == false:
			velocity = velocity.bounce(collision.get_normal())
			if collision.get_collider().is_in_group("paddle"):
				cc = true
				ccTimer.start() 
				collision.get_collider().ballCollide = true
				velocity += (collision.get_collider().velocity * boostSpeed) # when hit paddle while moving, add speed
				if velocity.y < maxySpeed:
					velocity.y = velocity.y * 1.025
				elif velocity.x < maxxSpeed:
					velocity.x = velocity.x * 1.025
			elif collision.get_collider().is_in_group("blocks"):
				var colBlock = collision.get_collider()
				colBlock.kill()
				if velocity.y < maxySpeed:
					velocity.y = velocity.y * 1.005
				elif velocity.x < maxxSpeed:
					velocity.x = velocity.x * 1.005
			elif collision.get_collider().is_in_group("balls"):
				collision.get_collider().velocity.bounce(collision.get_normal())
			collision = null
	else:
		set_collision_layer_value(1, false)
		set_collision_layer_value(9, false)
		set_collision_layer_value(10, true) # so it doesnt hit the paddle as it falls but is still deleted
		set_collision_mask_value(1, false)
		set_collision_mask_value(9, false)
		set_collision_mask_value(10, true)
		
		velocity = Vector2((velocity.x), (-6+falling))
		falling += 0.2
		move_and_collide(velocity)


func _on_collision_cooldown_timeout():
	cc = false
