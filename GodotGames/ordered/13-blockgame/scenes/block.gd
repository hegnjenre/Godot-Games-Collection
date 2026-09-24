extends CharacterBody2D

@export var speed = 12
var extraSpeed = 1.0
@export var health = 10
@export var blockColor: Color = Color(1,1,1)
@export var attackSetup = [0,0,0,0]

@onready var attackLeft = $defaultAttack/attackLeft
@onready var collisionLeft = $defaultAttackCollision/CollisionShapeLeft
@onready var attackRight = $defaultAttack/attackRight
@onready var collisionRight = $defaultAttackCollision/CollisionShapeRight
@onready var attackTop = $defaultAttack/attackTop
@onready var collisionTop = $defaultAttackCollision/CollisionShapeTop
@onready var attackBottom = $defaultAttack/attackBottom
@onready var collisionBottom = $defaultAttackCollision/CollisionShapeBottom

@onready var hBar = $blockHealth/ProgressBar
@onready var blockMods = $blockMods

@onready var testMod = $blockMods/wallSpeed
@onready var modifiers = [testMod]

var ranDir = 0
var collided = false
var active = false
var inAA = false

#checks
var wallCollided = false
var enemyCollided = false

func _ready():
	_update_default_attacks()
	self.modulate = blockColor
	ranDir = deg_to_rad(randi_range(0,359))
	velocity = Vector2(speed, 0).rotated(ranDir)
	hBar.max_value = health
	hBar.value = health

func _physics_process(_delta):
	hBar.value = health
	if active == true:
		var collision = move_and_collide(velocity * extraSpeed)
		if collision != null:
			if collision.get_collider().is_in_group("wall") == true:
				velocity = velocity.bounce(collision.get_normal())
			elif collision.get_collider().is_in_group("blocks") == true:
				#print(str(self.name) + " collided")
				enemyCollided = true
				var collider = collision.get_collider() #use a area2d signal to detect when they leave colliding range
				collider.velocity = collider.velocity.bounce(collision.get_normal())
				if inAA == true:
					collision.get_collider().health -= 1
					inAA = false
					collision = null
		if health <= 0:
			queue_free()

func _on_default_attack_collision_body_entered(body):
	if body.is_in_group("wall") == true:
		wallCollided = true
	inAA = true

func _update_default_attacks():
	if attackSetup[0] == 1:
		attackLeft.visible = true
		collisionLeft.disabled = false
	else:
		attackLeft.visible = false
		collisionLeft.disabled = true
		
	if attackSetup[1] == 1:
		attackRight.visible = true
		collisionRight.disabled = false
	else:
		attackRight.visible = false
		collisionRight.disabled = true
		
	if attackSetup[2] == 1:
		attackTop.visible = true
		collisionBottom.disabled = false
	else:
		attackTop.visible = false
		collisionBottom.disabled = true
		
	if attackSetup[3] == 1:
		collisionTop.disabled = false
		attackBottom.visible = true
	else:
		collisionTop.disabled = true
		attackBottom.visible = false



