extends CharacterBody2D

@export var powerType = "null"

func _ready():
	#var randx = randi_range(-50,50) # debug
	#var randy = randi_range(-170,-80) # debug
	#velocity = Vector2(randx, randy) # debug
	pass

func _process(delta):
	
	velocity += Vector2(0,6)
	
	var collision = move_and_collide(velocity * delta)
	
	if Global.is_arena():
		if collision != null:
			if collision.get_collider().is_in_group("paddle"):
				collision.get_collider().powerup(powerType)
				self.queue_free()
			if collision.get_collider().is_in_group("wall"):
				velocity.x = 0
				if velocity.y < 0:
					velocity.y = 0
