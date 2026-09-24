extends CharacterBody3D

@onready var symbolNode = $symbolNode
@onready var interactSymbol = $symbolNode/interactSymbol
@onready var inventoryUI = $UI/Inventory
@onready var shopExitButton = $UI/shopExit
@onready var inventoryNode = $inventory
@onready var battleUI = $UI/battleUI
@onready var battleOptions = $UI/battleUI/options
@onready var physicalOptions = $UI/battleUI/physical
@onready var backButton = $UI/battleUI/back
@onready var atkCooldown = $attackCooldown

#unarmed equips
@onready var baseHLoad = preload("res://Assets/items/no_helmet.tscn")
@onready var baseALoad = preload("res://Assets/items/no_armor.tscn")
@onready var baseLLoad = preload("res://Assets/items/no_legs.tscn")
@onready var baseWLoad = preload("res://Assets/items/unarmed.tscn")
@onready var baseDLoad = preload("res://Assets/items/unarmed_(defence).tscn")

@onready var baseH = baseHLoad.instantiate()
@onready var baseA = baseALoad.instantiate()
@onready var baseL = baseLLoad.instantiate()
@onready var baseW = baseWLoad.instantiate()
@onready var baseD = baseDLoad.instantiate()

var interactVisible = false

var health = 100
var stamina = 100
var resilience = 0.2

var damage = 1

const speed = 10.0
const jumpVel = 10
var yVelocity = 0
var grounded = false
var maxFallSpeed = 9.8
var camDist = 0
var prevDist = 0
var controllable = true
var exitBattle = false
var attackable = true

var inventory = []
var invNames = [] 
var invLoc = Vector3()
var shopExit = false

#equip slots
@onready var headEq = baseH
@onready var chestEq = baseA
@onready var legsEq = baseL
@onready var weaponEq = baseW
@onready var defenceEq = baseD

@onready var equipArray = [headEq, chestEq, legsEq, weaponEq, defenceEq]
var atkMod = 0.0
var defMod = 0.0
var eqIndex = 0

func _ready():
	invLoc = inventoryNode.get_global_position()
	eqIndex = 0
	
	for eq in equipArray:
		atkMod += eq.damageMult
		defMod += eq.defenceMult
		if eqIndex != 3:
			resilience += eq.defence
		eqIndex += 1
	
	damage += weaponEq.damage * atkMod
	resilience = resilience * defMod

func _physics_process(delta):
	equipArray = [headEq, chestEq, legsEq, weaponEq, defenceEq]
	
	var targetCam = get_viewport().get_camera_3d()
	
	var moveDir = 0
	var turnDir = 0
	
	if Input.is_action_pressed("forward") and controllable == true:
		moveDir += -1
	elif Input.is_action_pressed("backward") and controllable == true:
		moveDir += 1
	
	if Input.is_action_pressed("right"):
		turnDir += -1
	elif Input.is_action_pressed("left"):
		turnDir += 1
	
	if Input.is_action_just_pressed("inv"):
		pass #open inventory
	
	rotation_degrees.y += turnDir * 180 * delta
	velocity = global_transform.basis.z * speed * moveDir
	velocity.y = yVelocity
	
	move_and_slide()
	
	grounded = is_on_floor()
	yVelocity -= 9.8 * delta
	if grounded == true:
		yVelocity = -0.1
	if yVelocity > maxFallSpeed:
		yVelocity = -maxFallSpeed
	
	#interact symbol
	symbolNode.look_at(targetCam.get_global_position(), Vector3.UP)
	camDist = symbolNode.get_global_position().distance_to(targetCam.get_global_position())
	
	if camDist > prevDist:
		interactSymbol.pixel_size += 0.0002
	elif camDist < prevDist:
		interactSymbol.pixel_size -= 0.0002
	prevDist = camDist
	
	if interactVisible == true:
		symbolNode.visible = true
	elif interactVisible == false:
		symbolNode.visible = false
		interactSymbol.pixel_size = 0.05

func _process(_delta):
	inventoryUI.text = str(invNames)

func addToInv(item):
	item.global_position = invLoc
	inventory.append(item)
	invNames.append(item.title)

func _on_shop_exit_pressed():
	shopExit = true

func _on_physical_button_pressed():
	battleOptions.visible = false
	physicalOptions.visible = true
	backButton.visible = true

func _on_faith_button_pressed():
	pass # Replace with function body.

func _on_run_button_pressed():
	controllable = true
	exitBattle = true
	battleUI.visible = false
	battleOptions.visible = true
	physicalOptions.visible = false
	attackable = false
	atkCooldown.start(4)

func _on_regular_attack_pressed():
	print("attack")

func _on_regular_defend_pressed():
	print("defend")

func _on_special_attack_pressed():
	print("specialattack")

func _on_special_defend_pressed():
	print("specialdefend")

func _on_back_pressed():
	battleOptions.visible = true
	physicalOptions.visible = false
	backButton.visible = false

func _on_attack_cooldown_timeout():
	attackable = true
