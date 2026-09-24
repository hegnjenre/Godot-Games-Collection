extends Node2D

var root = get_tree().root
var originalScene = preload("res://Scenes/debug_scene.tscn")

@onready var tubeShop = $shopUI/coinTubes

func _on_coin_tube_open_pressed():
	tubeShop.visible = true

func _on_exit_button_pressed():
	var backScene = originalScene.instantiate()
	root.add_child(backScene)
	self.queue_free()
