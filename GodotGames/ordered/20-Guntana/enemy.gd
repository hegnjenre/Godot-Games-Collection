extends CharacterBody2D

var health = 10

@onready var health_label = $debug/debugText/health

func _ready():
	health_label.text = ("Health: " + str(health))

func _process(_delta):
	pass

func do_damage(damage):
	health -= damage
	if health <= 0:
		queue_free()
		return
	health_label.text = ("Health: " + str(health))
