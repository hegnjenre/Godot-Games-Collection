extends Node2D

@onready var arena = $Arena
@onready var carExit = $car
@onready var elevator = $elevatorInteract
@onready var endStatsUI = $endStatsUI

var eod = false
var closed = false

func _process(delta):
	if Global.is_end_of_day() and eod == false:
		eod = true
		#Global.get_playerChar().debugCam.enabled = true
		elevator.enabled = false
	elif Global.is_end_of_day() == false and closed == false:
		closed = true
		carExit.carInteract.enabled = false

func _on_exit_area_body_entered(body):
	if body.is_in_group("char"):
		showEndStats()

func showEndStats():
	endStatsUI.display = true
