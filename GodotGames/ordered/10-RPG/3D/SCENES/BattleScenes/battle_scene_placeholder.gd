extends Node3D

var opt = preload("res://3D/SCENES/BattleScenes/attack_default.tscn")
var debugWep = preload("res://debugWeapon.gd")

@onready var ebug = get_node("MainPlayer")

@onready var charArray = [ebug] # total number of characters (player and enemy) in the scene: initiated in turn order
var turnCounter = 0
var turnTaken = false

var attackChosen = false # either attack or magic has been chosen this turn
var itemChosen = false # item has been chosen this turn
var fleeChosen = false # flee has been chosen this turn
var currentChar = null
var currentDiceResults = [] #diceroll script replaces this

func _ready():
	pass

func turn():
	# await move
	if attackChosen:
		attackChosen = false
		# roll dice for hit
		#    play animation if miss/hit
		#       do attack effect (damage/status effect)
	elif itemChosen:
		itemChosen = false
		# play animation for item
		#    do item effect
	elif fleeChosen:
		fleeChosen = false
		# roll dice for flee
		#    play animation for fleeing/failure
		#       do flee failure effect if failed
		
	# turnTaken only true after animation finished 
	
	if turnTaken == true:
		turnCounter += 1
		currentChar = charArray[turnCounter]
		currentChar = camSwitch(currentChar)

func camSwitch(currentChar):
	#print("switch: " + str(charArray[turnCounter]))
	currentChar = charArray[turnCounter] # debug!!!!!!!!!!!!!!!!!!!!!!!!!!!
	currentChar.cam.current = true
	var newWep = debugWep.new()
	newWep._ready()             ## READY MUST ME MANUALLY CALLED TO INITIATE ITEMS ADDED TO INV
	currentChar.equipped.append(newWep)
	currentChar.refreshWeaponOptions()
	return currentChar

func _process(delta):
	if len(currentDiceResults) > 0:
		print(currentDiceResults)
		currentDiceResults = []
	if Input.is_action_just_pressed("debug"):
		currentChar = camSwitch(currentChar)

func generateOptions(type, char):
	var chosenMove = get_node(("BattleUI/" + type))
	var optionsPos = get_node("BattleUI/optionsPos")
	var optOffset = 0
	
	if type == "Attack":
		for option in char.attackOptions:
			var newDefaultOption = opt.instantiate()
			var optionLabel = newDefaultOption.get_child(0)
			newDefaultOption.name = option
			optionLabel.text = option
			chosenMove.add_child(newDefaultOption)
			var newOptionPos = Vector2((optionsPos.get_global_position().x), (optionsPos.get_global_position().y + optOffset))
			optOffset += 64
			newDefaultOption.global_position = newOptionPos
	elif type == "Defend":
		pass
	elif type == "Item":
		pass
	elif type == "Flee":
		pass

func _on_attack_pressed():
	currentChar.cam.current = false
	currentChar.optionCam.current = true
	generateOptions("Attack", currentChar)

func _on_magic_pressed():
	generateOptions("Magic", currentChar)

func _on_item_pressed():
	generateOptions("Item", currentChar)

func _on_flee_pressed():
	generateOptions("Flee", currentChar)
