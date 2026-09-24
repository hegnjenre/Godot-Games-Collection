extends Control

@onready var dayEnd = $dayEnd
@onready var bits = $bits
@onready var bitsNum = $bitsNum
@onready var coins = $coins
@onready var coinsNum = $coinsNum
@onready var exitButton = $exitButton
@onready var delay = $delay

var sectionNum = 0

var delayed = true
var display = false

func _process(_delta):
	if display == true and delayed == true:
		delay.start()
		delayed = false
		if sectionNum == 0:
			dayEnd.visible = true
		elif sectionNum == 1:
			bits.visible = true
			coins.visible = true
			bitsNum.set_text(str(Global.get_bits()))
			coinsNum.set_text(str(Global.get_gold()))
			bitsNum.visible = true
			coinsNum.visible = true
		elif sectionNum == 2:
			exitButton.visible = true
		sectionNum += 1

func _on_delay_timeout():
	delayed = true
