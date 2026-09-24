extends Node3D

var diceRoll = preload("res://3D/SCENES/DiceScenes/diceRoll.tscn")

@onready var camRig = $CamPoint
@onready var cam = $CamPoint/Camera3D
@onready var optionCam = $optionCam
@onready var diceCam = $diceCam
@onready var rollPos = $rollPos
var spincount = 0
var equipped = [] # equipped item array NOT for listing equipped items, must for finding all of them easier
var attackOptions = []
var attackDict = {}
var defendOptions = [] # going to change the options to Attack / Defend, so different options for each

func _ready():
	refreshWeaponOptions()

func refreshWeaponOptions():
	for item in equipped:
		#print(item.type)
		if item.type == "weapon":
			#print(item.attacks)
			for i in range(0, len(item.attacks)):
				attackOptions.append(item.attacks[i])
				attackDict[item.attacks[i]] = item.damageDice

func _process(delta):
	camSpin(delta)

func camSpin(delta):
	if spincount < 65 and spincount < 130:
		camRig.rotation_degrees += Vector3(0, (2 * delta), 0)
		spincount += 0.2
	elif spincount > 65 and spincount < 130:
		camRig.rotation_degrees -= Vector3(0, (2 * delta), 0)
		spincount += 0.2
	elif spincount >= 130:
		spincount = 0

func doAttack(type):
	optionCam.current = false
	diceCam.current = true
	var newDice = diceRoll.instantiate()
	get_parent().add_child(newDice)
	newDice.position = rollPos.position
	newDice.rollDice(attackDict[type])
	
