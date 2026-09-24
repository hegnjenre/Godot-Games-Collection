extends CharacterBody2D

@export var speed = 100.0
@onready var animator = $AnimatedSprite2D
@onready var killed = false
@onready var leftCast = $rayCasts/leftCast
@onready var rightCast = $rayCasts/rightCast
@onready var visionCast = $rayCasts/visionCast
@onready var aimingUI = $enemyUI/aiming
var sprintSpeed = (speed * 1.75)
var attackWindup = 100

#AI States
var idle = true
var attacking = false
var pathMoving = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animator.play("idle")



