extends Node2D

@onready var pBlock = $playerBlock
@onready var eBlock = $enemyBlock

func _ready():
	pBlock.active = true
	eBlock.active = true
