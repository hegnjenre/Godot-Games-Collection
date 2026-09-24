extends StaticBody2D

@export var pName = "Null"
@export var bits = 10

@onready var gotLabel = $Label

var blockID = 0
var blockLayer = 0
var killed = false

var ETime = preload("res://Minor Scenes/Blocks/Powerups/extraTime.tscn")
var EBall = preload("res://Minor Scenes/Blocks/Powerups/extraBall.tscn")
var WPaddle = preload("res://Minor Scenes/Blocks/Powerups/widerPaddle.tscn")
var Gold = preload("res://Minor Scenes/Blocks/Powerups/Gold.tscn")

var powerDict = {"ET":ETime, "EB":EBall, "WP":WPaddle, "G":Gold}

func kill():
	var blocks = get_parent().spawnedBlockArray
	Global.add_bits(bits)
	dropPowerup()
	blocks[blockLayer][blockID] = null
	self.queue_free()

func exKill():
	var blocks = get_parent().spawnedBlockArray
	Global.add_bits(bits)
	blocks[blockLayer][blockID] = null
	self.queue_free()

func dropPowerup():
	if killed == false:
		killed = true
		if pName != "Null":
			if pName != "EX":
				var newPower = powerDict[pName].instantiate()
				get_parent().add_child(newPower)
				newPower.global_position = get_global_position()
				var randx = randi_range(-60, 60)
				var randy = randi_range(-170, -80)
				newPower.velocity = Vector2(randx, randy)
			else: # explosive
				var blocks = get_parent().spawnedBlockArray
				if (blockID-1) >= 0 and blocks[blockLayer][blockID-1] != null and blocks[blockLayer][blockID-1].get_global_position().y == self.get_global_position().y: #left
					if blocks[blockLayer][blockID-1].pName != "EX":
						blocks[blockLayer][blockID-1].exKill()
					else:
						blocks[blockLayer][blockID-1].kill()
				if (blockID+1) <= (len(blocks[blockLayer])-1) and blocks[blockLayer][blockID+1] != null and blocks[blockLayer][blockID+1].get_global_position().y == self.get_global_position().y: #right
					if blocks[blockLayer][blockID+1].pName != "EX":
						blocks[blockLayer][blockID+1].exKill()
					else:
						blocks[blockLayer][blockID+1].kill()
				print("blockLayer: " + str(blockLayer))
				print("blockID: " + str(blockID))
				if (blockLayer-1) >= 0 and (blockLayer-1) < len(blocks) and blocks[blockLayer-1][blockID] != null: #below
					if blocks[blockLayer-1][blockID].pName != "EX":
						blocks[blockLayer-1][blockID].exKill()
					else:
						blocks[blockLayer-1][blockID].kill()
				if (blockLayer+1) < len(blocks) and blocks[blockLayer+1][blockID] != null: #above
					if blocks[blockLayer+1][blockID].pName != "EX":
						blocks[blockLayer+1][blockID].exKill()
					else:
						blocks[blockLayer+1][blockID].kill()
		else:
			pass
