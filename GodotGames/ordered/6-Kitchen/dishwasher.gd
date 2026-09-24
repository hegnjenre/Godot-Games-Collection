extends CharacterBody2D

var dish = preload("res://dish.tscn")

@onready var dishwasher = get_node("../dishwasher")
@onready var armArea = get_node("../dishwasher/armArea")
@onready var dishSpawners = get_node("../dishSpawners")
@onready var navAgent:= $NavigationAgent2D as NavigationAgent2D

#@export var player: this creates an inspector element !!!!

var chosenSpawner = null
var emptyhand = true
var heldDish = null
var pos = Vector2(0,0)
var spawnerPos = Vector2(0,0)
var dist = 0
var navPos = Vector2(0,0)


var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
	pos = dishwasher.get_position()
	
	while chosenSpawner == null:
		for i in range(0, dishSpawners.get_child_count()):
			var spawner = dishSpawners.get_child(i)
			if spawner.plates > 0:
				chosenSpawner = spawner
	
	spawnerPos = chosenSpawner.get_position() + chosenSpawner.dishPoint.get_position()
	
	#dist = sqrt((spawnerPos.x - pos.x)**2+(spawnerPos.y - pos.y)**2)
	

func _physics_process(_delta:float):
	
	if emptyhand == true:
		navPos = spawnerPos
	elif heldDish != null and heldDish.dirty == true:
		#navPos = sinkPos
		pass
	elif heldDish != null and heldDish.unwashed == true:
		#navPos = trayPos
		pass
	
	var dir = to_local(navAgent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func createPathing():
	navAgent.target_position = navPos

func _on_timer_timeout():
	createPathing()

func _on_arm_area_area_entered(area):
	if area.name == "spawnerArea":
		var dishInstance = dish.instantiate()
		dishwasher.add_child(dishInstance)
		emptyhand = false
