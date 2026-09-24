extends RigidBody2D

@export var maxObjHealth = 1
var objHealth = 1

@onready var rootNode = get_node("/root")
@onready var pieceNode = $destructNode
@onready var pieces = pieceNode.pieces

func _ready():
	pass

func _break():
	if len(pieces) > 0:
		if maxObjHealth <= 1:
			self.visible = false
			for i in range(0, len(pieces)):
				var newPiece = pieces[i].instantiate()
				newPiece.global_position = self.get_global_position()
				var vectorX = randi_range(190, 280)
				var vectorY = randi_range(-380, -260)
				newPiece.vecX = vectorX
				newPiece.vecY = vectorY
				rootNode.call_deferred("add_child", newPiece)
			self.call_deferred("queue_free")
