extends CharacterBody2D

var objId = 0

func _ready():
	objId = Global.add_obj(self)
