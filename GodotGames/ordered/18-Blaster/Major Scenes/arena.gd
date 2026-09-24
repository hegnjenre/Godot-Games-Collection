extends Node2D

var defaultBlock = preload("res://Minor Scenes/Blocks/defaultBlock.tscn")
var etBlock = preload("res://Minor Scenes/Blocks/etBlock.tscn")
var ebBlock = preload("res://Minor Scenes/Blocks/ebBlock.tscn")
var wpBlock = preload("res://Minor Scenes/Blocks/wpBlock.tscn")
var gBlock = preload("res://Minor Scenes/Blocks/gBlock.tscn")
var exBlock = preload("res://Minor Scenes/Blocks/exBlock.tscn")

var blockArray = [defaultBlock, etBlock, ebBlock, wpBlock, exBlock, gBlock]
var spawnedBlockArray = []

@onready var timer = $dayTimer
@onready var rowTimer = $rowTimer
@onready var timerLabel = $rightUI/Time
@onready var timerAdd = $rightUI/Add
@onready var timerFade = $endTextTimer
@onready var leftUI = $leftUI
@onready var rightUI = $rightUI

var start = false
var participle = "mins."
var strTime = ""
var alpha = 1

@onready var xy = [160, 172]
@onready var curLayer = 0
var highestLayer = 0
var lowestLayer = []
var reLayer = false
var rowTimerON = false #//
var stopRows = false

var endFade = false
var fade = 0.8

func _ready():
	timer.set_wait_time(1)
	rowTimer.set_wait_time(20)
	for i in range(0, 6):
		xy = spawn_row(xy, curLayer)
		curLayer += 1
		highestLayer = i

func _process(_delta):
	if endFade == true and fade >= 0:
		fade -= 0.025
		timerAdd.label_settings.set_font_color(Color(1,1,1,fade))
		timerAdd.label_settings.set_outline_color(Color(0,0,0,fade))
	
	for block in lowestLayer:
		if block != null and block.get_global_position().y >= 260 and stopRows == false:
			rowTimer.stop()
			stopRows = true
		elif block != null and block.get_global_position().y < 250 and stopRows == true:
			rowTimer.start()
			stopRows = false
	
	if start == false and Input.is_action_just_pressed("enter") and get_parent().get_node("playerChar").in_chair == true:
		Global.arena_on()
		rowTimer.start()
		timer.start()
		start = true
	
	
	if start == true and (lowestLayer.is_empty() == true or reLayer == true):
		lowestLayer.clear()
		var i = 0
		var foundLayer = false
		while i <= len(spawnedBlockArray) and foundLayer == false:
			for x in range(0, len(spawnedBlockArray[i])):
				if spawnedBlockArray[i][x] != null:
					lowestLayer = spawnedBlockArray[i]
					foundLayer = true
			i += 1
		reLayer = false
	if Global.is_arena():
		if start == true and reLayer == false:
			var i = 0
			var empty = false
			while i < len(lowestLayer) and empty == false:
				if lowestLayer[i] != null:
					empty = true
				i += 1
			if empty == false: #and rowTimerON == false: disabled for now
				reLayer = true
				#rowTimer.start()
				#rowTimerON = true
		
		if timerAdd.label_settings.font_color.a > 0:
			timerAdd.label_settings.set_font_color(Color(1,1,1,alpha))
			timerAdd.label_settings.set_outline_color(Color(0,0,0,alpha))
			alpha -= 0.005
	
	var time = (timer.time_left / 60)
	if time >= 1:
		participle = " minutes."
		strTime = str(round(time))
	else:
		participle = " seconds."
		strTime = str(round(timer.time_left))
	timerLabel.text = (strTime + participle)


func spawn_row(xy, layer):
	var newArray = []
	var idCount = 0
	for i in range(0, 9):
		var chosen = randomise()
		var newBlock = blockArray[chosen].instantiate()
		add_child(newBlock)
		newBlock.blockID = idCount
		newBlock.blockLayer = layer
		newBlock.name = "block " + str(layer) + "_" + str(idCount) 
		idCount += 1
		newBlock.gotLabel.text = str(newBlock.blockID) # debug
		newArray.append(newBlock)
		newBlock.global_position = Vector2(xy[0], xy[1])
		xy[0] += 40
	spawnedBlockArray.append(newArray)
	xy[0] = 160
	xy[1] -= 28
	return xy

func next_row():
	for subArray in spawnedBlockArray:
		for block in subArray:
			if block != null:
				block.global_position.y += 28
	xy[1] += 28
	xy = spawn_row(xy, curLayer)
	highestLayer = curLayer
	curLayer += 1

func randomise():
	var randPerc = snappedf(randf_range(1,100), 0.1)
	var chosen = 0
	
	#spawnChance:
	#  default = 70%
	#  et = 12.5%
	#  eb = 5%
	#  wp = 5%
	#  ex = 5%
	#  gold = 2.5%
	
	if randPerc <= 70: # default
		pass
	elif randPerc > 70 and randPerc <= 82.5: # et
		chosen = 1
	elif randPerc > 82.5 and randPerc <= 87.5: # eb
		chosen = 2
	elif randPerc > 87.5 and randPerc <= 92.5: # wp
		chosen = 3
	elif randPerc > 92.5 and randPerc <= 97.5: # ex
		chosen = 4
	elif randPerc > 97.5 and randPerc <= 100: # g
		chosen = 5
	return chosen

func addOpaque():
	alpha = 0.65
	timerAdd.text = "+10s"
	timerAdd.label_settings.set_font_color(Color(1,1,1,0.65))
	timerAdd.label_settings.set_outline_color(Color(0,0,0,0.65))

func _on_cullarea_body_entered(body):
	body.queue_free()

func _on_day_timer_timeout():
	timerAdd.text = "Day End"
	timerAdd.label_settings.font_size = 100
	timerAdd.label_settings.set_font_color(Color(1,1,1,0.8))
	timerAdd.label_settings.set_outline_color(Color(0,0,0,0.8))
	Global.arena_off()
	Global.set_eod(true)
	get_parent().get_node("playerChar").set_global_position(Vector2(530,352))
	get_parent().get_node("playerChar").sprite.scale.x = 1
	get_parent().get_node("playerChar").can_move = true
	get_parent().get_node("playerChar").in_chair = false
	timerFade.start()

func _on_row_timer_timeout():
	if Global.is_arena():
		next_row()
		#rowTimerON = false

func _on_end_text_timer_timeout():
	endFade = true
	leftUI.fading = true
	rightUI.fading = true
