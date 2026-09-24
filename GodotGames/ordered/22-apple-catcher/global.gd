extends Node

var applePoints = 0
var puzzleSolved = false
var chosenPuzzle = ""

#"debug":preload("res://scenes/puzzles/puzzles/puzzle_board_debug.tscn")
#"debug":preload("res://sprites/puzzles/placeholderPuzzleIcon.png")
#"debug":false

var allPuzzles = {"puzzle1":preload("res://scenes/puzzles/puzzles/puzzle_board_1.tscn"),
				  "puzzle2":preload("res://scenes/puzzles/puzzles/puzzle_board_2.tscn"),
				  "puzzle3":preload("res://scenes/puzzles/puzzles/puzzle_board_3.tscn"),
				  "puzzle4":preload("res://scenes/puzzles/puzzles/puzzle_board_4.tscn"),}
var allPuzzleIcons = {"puzzle1":preload("res://sprites/puzzles/placeholderPuzzleIcon.png"),
					  "puzzle2":preload("res://sprites/puzzles/placeholderPuzzleIcon.png"),
					  "puzzle3":preload("res://sprites/puzzles/placeholderPuzzleIcon.png"),
					  "puzzle4":preload("res://sprites/puzzles/placeholderPuzzleIcon.png"),}
var completion = {"puzzle1":false,
				  "puzzle2":false,
				  "puzzle3":false,
				  "puzzle4":false,}

func add_point():
	applePoints += 1

func get_puzzle_icons():
	return allPuzzleIcons

func get_puzzle_list():
	return allPuzzles

func choose_puzzle(puzzle : String): ## gets key for chosen puzzle
	chosenPuzzle = puzzle

func clear_puzzle():
	chosenPuzzle = ""

func get_puzzle(): ## returns preloaded scene for chosen puzzle
	return allPuzzles.get(chosenPuzzle)

func complete_puzzle():
	completion.set(chosenPuzzle, true)

func get_chosen_puzzle():
	return chosenPuzzle

func is_puzzle_solved():
	return puzzleSolved

func puzzle_is_solved():
	puzzleSolved = true
	complete_puzzle()

func unsolve_puzzle():
	puzzleSolved = false
