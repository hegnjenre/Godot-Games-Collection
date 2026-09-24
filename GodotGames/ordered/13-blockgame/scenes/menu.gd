extends Node2D

@onready var titleScreen = $titleScreen
@onready var gameMenu = $gameMenu
@onready var totalBloins = $gameMenu/totalBloinsNUMBER

var blocksScene = preload("res://scenes/blocks.tscn")
var blockScene = preload("res://scenes/block.tscn")

func _process(_delta):
	totalBloins.text = str(PlayerStats.bloins)

func _on_play_button_pressed():
	titleScreen.visible = false
	gameMenu.visible = true
	PlayerStats.playerBlock = blockScene.instantiate()
	PlayerStats.playerBlock.name = "playerBlock" #replace this eventually with the saved block.
	

func _on_next_match_button_pressed():
	gameMenu.visible = false
	$menuCam.enabled = false
	var newMatch = blocksScene.instantiate()
	add_child(newMatch)
	newMatch.name = "newMatch"
	newMatch.get_node("cam").enabled = true
