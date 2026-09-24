extends CharacterBody2D

var speed = 1.4
var on_ground = false
var can_move = true
var in_chair = false

@onready var sprite = $AnimatedSprite2D
@onready var rayBack = $RayCast2D
@onready var rayFront = $RayCast2D2
@onready var debugCam = $Camera2D

func _ready():
	Global.set_playerChar(self)

func _process(_delta):
	if Global.is_arena(): # arena mode
		pass
	
	else:                 # char mode
		rayBack.force_raycast_update()
		rayFront.force_raycast_update()
		var rayCollision1 = rayBack.get_collider()
		var rayCollision2 = rayFront.get_collider()
		
		if (rayCollision1 != null and rayCollision1.is_in_group("ground")) or (rayCollision2 != null and rayCollision2.is_in_group("ground")):
			on_ground = true
		elif (rayCollision1 == null or rayCollision1.is_in_group("ground") == false) and (rayCollision2 == null or rayCollision2.is_in_group("ground") == false):
			on_ground = false
		
		if can_move == true:
			if Input.is_action_pressed("right"):
				velocity = Vector2(1,0)
				sprite.scale.x = 1
				sprite.play("walk")
			elif Input.is_action_pressed("left"):
				velocity = Vector2(-1,0)
				sprite.scale.x = -1
				sprite.play("walk")
			else:
				velocity = Vector2(0,0)
				sprite.play("idle")
			
			if on_ground == false:
				velocity += Vector2(0, 1)
			
			var collision = move_and_collide(velocity * speed)
