extends Node2D

@onready var blockGameUI = $blockGameUI
@onready var blockView = $blockGameUI/blockView
@onready var playerSpawn = $leftSpawn
@onready var enemySpawn = $rightSpawn
@onready var startButton = $blockGameUI/start
@onready var editButton = $blockGameUI/editBlock
@onready var blockViewUI = $blockGameUI/blockViewUI
@onready var modStart = $blockGameUI/blockViewUI/modStart

var blockScene = preload("res://scenes/block.tscn")
var block = null
var enemyBlock = null
var selectedBlock = null

func _ready():
	block = PlayerStats.playerBlock
	selectedBlock = block
	add_child(block)
	block.set_global_position(blockView.get_global_position())
	block.attackSetup = [1,1,0,0]
	block._update_default_attacks()
	enemyBlock = blockScene.instantiate()
	add_child(enemyBlock)
	enemyBlock.name = "enemyBlock"
	enemyBlock.set_global_position(enemySpawn.get_global_position())
	enemyBlock.attackSetup = [0,0,1,1]
	enemyBlock._update_default_attacks()

func _on_start_pressed():
	start()

func start():
	block.set_global_position(playerSpawn.get_global_position())
	if block.get_global_position() == playerSpawn.get_global_position():
		block.active = true
		block.get_node("blockHealth").visible = true
		enemyBlock.active = true
		enemyBlock.get_node("blockHealth").visible = true
		startButton.visible = false
		editButton.visible = false
		blockViewUI.visible = false
		block.blockMods.visible = false

func _on_edit_block_pressed():
	blockViewUI.visible = true
	displayModifiers(selectedBlock)

func displayModifiers(selected):
	var idx = 0
	var posX = 0
	var posY = 0
	for mod in selected.modifiers:
		mod.set_global_position(Vector2((modStart.get_global_position().x + posX), (modStart.get_global_position().y + posY)))
		mod.display_small()
		idx += 1
		posX += 70
	selected.blockMods.visible = true

func _on_leftattack_pressed():
	if block.attackSetup[0] == 1:
		block.attackSetup[0] = 0
	else:
		block.attackSetup[0] = 1
	block._update_default_attacks()

func _on_rightattack_pressed():
	if block.attackSetup[1] == 1:
		block.attackSetup[1] = 0
	else:
		block.attackSetup[1] = 1
	block._update_default_attacks()

func _on_topattack_pressed():
	if block.attackSetup[2] == 1:
		block.attackSetup[2] = 0
	else:
		block.attackSetup[2] = 1
	block._update_default_attacks()

func _on_bottomattack_pressed():
	if block.attackSetup[3] == 1:
		block.attackSetup[3] = 0
	else:
		block.attackSetup[3] = 1
	block._update_default_attacks()
