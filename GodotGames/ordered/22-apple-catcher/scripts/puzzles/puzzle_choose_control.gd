extends Control

signal puzzle_chosen

var prePuzzleButton = preload("res://scenes/table/puzzle_button.tscn")

@onready var puzzleContainer = $GridContainer

func _ready():
	unload_puzzles()

func emit_puzzle_chosen():
	emit_signal("puzzle_chosen")

func unload_puzzles():
	var puzzleIcons = Global.get_puzzle_icons()
	for pKey in puzzleIcons.keys():
		var newButton = prePuzzleButton.instantiate()
		newButton.icon = puzzleIcons.get(pKey)
		newButton.puzzleName = pKey
		newButton.controller = self
		puzzleContainer.add_child(newButton)
