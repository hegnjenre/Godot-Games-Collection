extends Node2D

@onready var inputPoint = $inputPoint
@onready var outputPoint = $outputPoint
@onready var prodTimer = $productionTimer
@onready var sprite = $AnimatedSprite2D
@onready var UIController = Global.get_ui_controller()
@onready var buildUIController = UIController.buildView

var inputChannel: Node = null
var outputChannel: Node = null

var hasInput = false
var cooldown = false
var placed = false
@export var activated = false
@export var inputResource = -1
@export var outputResource = -1
@export var produceCountdown = 2.0

func set_input_channel(channel):
	inputChannel = channel

func set_output_channel(channel):
	outputChannel = channel
	outputChannel.resource = outputResource

func produce():
	if outputChannel != null && outputChannel.resourcesQueued != outputChannel.resourcesMax:
		cooldown = true
		if inputResource == 0 || (inputChannel != null && ((inputResource == -1 || inputChannel.resource == inputResource) && inputChannel.resourcesQueued > 0)): ##correct resource or no resource needed
			if inputChannel != null:
				inputChannel.recieve()
			spawn_output()
		prodTimer.start()

func spawn_output():
	if outputChannel != null:
		outputChannel.send()
	else:
		pass
		#print(name + ": No Output Channel")

func _ready() -> void:
	prodTimer.wait_time = produceCountdown

func activate() -> void:
	activated = true
	sprite.play("activated")

func _process(delta: float) -> void:
	if placed:
		if Global.get_current_power() > 0 and activated == false:
			Global.take_power()
			activated = true
		elif Global.get_current_power() < 0 and activated == true:
			activated = false
			Global.return_power() ## i can forsee issues with this but we'll cross that blah blahshdgs
		if activated:
			if sprite.animation != "activated":
				sprite.play("activated")
			if !cooldown:
				produce()
		else:
			if sprite.animation != "deactivated":
				sprite.play("deactivated")
	

func _on_production_timer_timeout() -> void:
	cooldown = false

func _on_area_2d_mouse_entered() -> void:
	if UIController.buildMode:
		if buildUIController.hovered != self:
			buildUIController.hovered = self
			#print("hovered: " + self.name)

func _on_area_2d_mouse_exited() -> void:
	if UIController.buildMode:
		if buildUIController.hovered == self && buildUIController.hovered != null:
			buildUIController.hovered = null
