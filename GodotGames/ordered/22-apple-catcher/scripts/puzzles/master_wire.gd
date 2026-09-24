extends Node2D

var connections = []
var tilePos = Vector2()
var controller = null
var signaled = false
var rotNum = 1

@onready var sprite = $AnimatedSprite2D

@export var start = false
@export var end = false
@export var rotatable = false
@export var maxRot = 0
@export var validDirections = {"right":false, "down":false, "left":false, "up":false}
@export var rotatedDirections = {0:{"right":false, "down":false, "left":false, "up":false}, 1:{"right":false, "down":false, "left":false, "up":false}, 2:{"right":false, "down":false, "left":false, "up":false}, 3:{"right":false, "down":false, "left":false, "up":false}}
var directionTranslate = {Vector2i(1,0):"right", Vector2i(0,1):"down", Vector2i(-1,0):"left", Vector2i(0,-1):"up"}

func _ready():
	pass

func rotate_wire():
	#print("rot: " + str(rotNum))
	sprite.play(str(rotNum))
	validDirections = rotatedDirections.get(rotNum)
	rotNum += 1
	if rotNum == maxRot:
		rotNum = 0

func check_connections(cells):
	for cell in cells:
		if (cell.x >= 9 && cell.x <= 20) && (cell.y >= -1 && cell.y <= 11):
			## if on board, or start/end
			var dir = cell - tilePos # get cardinal direction of neighbouring cell
			if validDirections.get(directionTranslate.get(dir)): 
				## if cell is on board and is valid as a connection
				#print(str(cell) + " is valid")
				if controller.placedWires.get(cell) != null: ## if there is a wire at valid cell
					connections.append(controller.placedWires.get(cell))
					controller.placedWires.get(cell).connections.append(self)

func send_signal():
	signaled = true
	for connection in connections:
		if connection.end:
			print("victory")
			Global.puzzle_is_solved()
		elif connection.signaled == false:
			connection.send_signal()
