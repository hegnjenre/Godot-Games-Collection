extends "res://scripts/friendly/building/building_super.gd"

func _ready() -> void:
	prodTimer.wait_time = produceCountdown

func spawn_output():
	if outputResource == 0:
		outputResource = inputChannel.resource
	Global.add_resource(outputResource)
	#Global.print_resources()
