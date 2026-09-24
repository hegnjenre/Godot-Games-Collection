extends Node3D

@onready var root = get_tree().get_root()
@onready var board = get_tree().get_root().get_node("board")
@onready var playerCells = get_tree().get_root().get_node("board/playerCells")
@onready var enemyCells = get_tree().get_root().get_node("board/enemyCells")

@export var location = "debug"

var enemyBoard =   [[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]]] #entering unit setnames will spawn them on the enemy's board

var counterParts = {"soldierUnit":preload("res://2DAssets/Units/Human/Soldier/soldier_unit_3d.tscn"),
					"archerUnit":preload("res://2DAssets/Units/Human/Archer/archer_unit_3d.tscn"),
					"warriorUnit":preload("res://2DAssets/Units/Human/Warrior/warrior_unit_3d.tscn")
					}

var presetBoards = {"debug0":[[[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],["archerUnit"],[],[],[],[]]],
					"debug1":[[[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],["soldierUnit"],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],[],[],[],[],[],[],[],[]],
							  [[],["soldierUnit"],["soldierUnit"],["soldierUnit"],["soldierUnit"],[],[],[],[]]],} 

##OK SO DECIDED ON DOING IT LIKE PRESET FULL BOARDS OF WAVES, ONCE ALL ENEMIES ARE DEAD, MOVE ON TO NEXT WAVE  
##*location*0 means the starting board, and the next wave would be *location*1, and so on

var unitComps = {"debug":["soldierUnit", "archerUnit", "warriorUnit"],}
var wave = 0
var endWave = false

func _ready():
	placeUnits()

func placeUnits():
	var columnNum = 0
	for column in enemyBoard:
		for row in range(0, column.size()):
			if presetBoards.get(location+str(wave))[columnNum][row].size() > 0: #will break if wave is greater than number of preset waves obvs but good framework for now
				var setName = presetBoards.get(location+str(wave))[columnNum][row][0]
				var instUnit = counterParts.get(setName).instantiate()
				instUnit.enemyOrPlayer += 1
				enemyCells.get_node(board.boardDict[columnNum][row][0]).add_child(instUnit)
				instUnit.name = setName
				instUnit.position.y += 1.5
				instUnit.scale = Vector3(1.45,1.45,1)
				enemyBoard[columnNum][row].append(setName)
		columnNum += 1

func _physics_process(_delta):
	var isEmpty = true
	var columnNum = 0
	for column in enemyBoard:
		for row in range(0, column.size()):
			if enemyBoard[columnNum][row].size() > 0:
				isEmpty = false
		columnNum += 1
	if isEmpty == true:
		endWave = true
		wave += 1
