extends Node2D
@onready var UI = $UI
@onready var UIEnter = $UI/Enter

var travel = false
var info = false
var enter = false

func UIVisible():
	if UI.visible != true:
		UI.visible = true
func UIInvisible():
	if UI.visible != false:
		UI.visible = false

func _on_travel_pressed():
	travel = true

func _on_info_pressed():
	info = true

func _on_enter_pressed():
	enter = true
