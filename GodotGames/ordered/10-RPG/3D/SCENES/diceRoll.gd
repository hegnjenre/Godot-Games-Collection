extends Node3D

var d6 = preload("res://3D/SCENES/DiceScenes/d6.tscn")
@onready var ds = $diceSpawn
@onready var db = $diceBox
@onready var label = $Control/Label
@onready var timer = $diceTimer
var count = 0

var diceThrown = []
var diceResults = []
var diceStopped = false
var checkedCount = 0

var diceDict = {"d6":d6,
				}

func _ready():
	timer.wait_time = 2.0

func _process(_delta):
	for dice in diceThrown:
		if diceStopped == true and checkedCount < len(diceThrown):
			diceResults.append(checkAns(dice))
			dice.isMoving = false
			checkedCount += 1
		elif diceStopped == true and checkedCount >= len(diceThrown):
			checkedCount = 0
			diceStopped = false
			get_parent().currentDiceResults = diceResults
		
		if dice != null and dice.isMoving == true: 
			if (timer.is_stopped() == true) and (dice.linear_velocity <= Vector3(0.01,0.01,0.01) or dice.angular_velocity <= Vector3(0.01,0.01,0.01)):
				timer.start()
			elif dice.linear_velocity > Vector3(0.01,0.01,0.01) or dice.angular_velocity > Vector3(0.01,0.01,0.01):
				timer.stop()
	
	if Input.is_action_just_pressed("debug"):
		rollDice(["d6", "d6"])

func rollDice(diceArray):
	for dice in diceArray:
		var newdice = diceDict[dice].instantiate()
		newdice.isMoving = true
		diceThrown.append(newdice)
		var randVec = Vector3(randi(), randi(), randi())
		var randDir = Vector3(randi_range(-10, 10), randi_range(-10, 10), randi_range(-10, 10))
		add_child(newdice)
		newdice.rotation = randVec
		newdice.global_position = ds.global_position
		newdice.apply_impulse(randDir)

func checkAns(dice):
	var ans = 0
	for node in dice.normals:
		node.force_raycast_update()
		if node.get_collider() != null and node.get_collider().name == "floor":
			var floorNum = node.name
			ans = dice.opposites[floorNum]
	return ans


func _on_dice_timer_timeout():
	timer.stop()
	diceStopped = true
