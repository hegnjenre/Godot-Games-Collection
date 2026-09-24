extends CharacterBody2D

@onready var nav = $NavigationAgent2D
var targetPosition = null

func _physics_process(delta):
	var direction = Vector2.ZERO 
	
	direction = nav.get_next_path_position() - global_position
	direction.normalized()
	
	velocity = velocity.lerp(direction * 4, 1)
	move_and_slide()

func updateNav():
	nav.target_position = targetPosition
	
