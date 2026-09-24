extends Node3D

@onready var camera = $view
@onready var ray = RayCast3D.new()
@onready var mouseArea = $Area2D 
@onready var enemyGM = $enemyGM
@onready var playerCells = $playerCells
@onready var enemyCells = $enemyCells
@onready var boardUI = $view/boardUI
var selectedBody = null
var areaSelected = null
var selectedCell = null
var selectedAttackingCell = null
var selectedUnit = null
var prevBody = null

var playerTurn = true

var playerBoard =  [[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]],
					[[],[],[],[],[],[],[],[],[]]]
					
var boardDict = [[["A1"],["A2"],["A3"],["A4"],["A5"],["A6"],["A7"],["A8"],["A9"]],
				 [["B1"],["B2"],["B3"],["B4"],["B5"],["B6"],["B7"],["B8"],["B9"]],
				 [["C1"],["C2"],["C3"],["C4"],["C5"],["C6"],["C7"],["C8"],["C9"]],
				 [["D1"],["D2"],["D3"],["D4"],["D5"],["D6"],["D7"],["D8"],["D9"]],
				 [["E1"],["E2"],["E3"],["E4"],["E5"],["E6"],["E7"],["E8"],["E9"]],
				 [["F1"],["F2"],["F3"],["F4"],["F5"],["F6"],["F7"],["F8"],["F9"]],
				 [["G1"],["G2"],["G3"],["G4"],["G5"],["G6"],["G7"],["G8"],["G9"]],
				 [["H1"],["H2"],["H3"],["H4"],["H5"],["H6"],["H7"],["H8"],["H9"]],
				 [["I1"],["I2"],["I3"],["I4"],["I5"],["I6"],["I7"],["I8"],["I9"]]]

func _ready():
	ray.set_name("cellCast")
	camera.add_child(ray)
	selectedUnit = null
	boardUI.restockUnitList()

func _physics_process(delta):
	selectedBody = areaSelected
	var space_state = get_world_3d().direct_space_state
	var mouse = get_viewport().get_mouse_position()
	mouseArea.global_position = mouse
	
	#print("select: " + str(selectedBody))
	#print("prev: " + str(prevBody))
	if selectedBody != null and selectedBody.is_in_group("unitGroup"):
		selectedBody._on_mouse_entered()
		#prevBody = selectedBody
	#elif (selectedBody == null or (selectedBody != null and selectedBody.is_in_group("unitGroup") == false)) and (prevBody != null and prevBody.is_in_group("unitGroup") == true and prevBody.clicked != true):
	#	prevBody._on_mouse_exited()
	
	var origin = camera.project_ray_origin(mouse)
	var end = origin + camera.project_ray_normal(mouse) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	var collider = result.get("collider")
	selectedCell = null
	selectedAttackingCell = null
	if collider != null: #3d mouse detection
		#print(result.get("collider").is_in_group("playerCells"))
		#print(result.get("collider").is_in_group("enemyCells"))
		if collider.is_in_group("playerCells") or collider.is_in_group("enemyCells"):
			selectedCell = collider
			selectedAttackingCell = collider
			selectedUnit = null
		elif collider.is_in_group("3DUnitGroup"):
			#print(result.get("collider"))
			selectedUnit = collider.get_parent()
			selectedUnit.hovered = true
	else:
		selectedUnit = null
		selectedCell = null
		
		
	if playerTurn == false:
		enemyTurn() #BIG idea, have translucent versions of the units where the enemy will place them in the next wave, so the player can plan accordingly I AM LITERALLY MAKING LARGER FUCKING INSCRYPTION AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		
	if enemyGM.endWave == true:
		##end of wave
		enemyGM.placeUnits()
		enemyGM.endWave = false
		boardUI.restockUnitList()

func _on_area_2d_body_entered(body):
	areaSelected = body

func _on_area_2d_body_exited(body):
	areaSelected = null

func enemyTurn():
	var columnNum = 0
	#print("enemy attacks")
	for column in enemyGM.enemyBoard:
		for row in range(0, column.size()):
			if enemyGM.enemyBoard[columnNum][row].size() > 0:
				enemyCells.get_node(boardDict[columnNum][row][0]).get_child(1).attack()
		columnNum += 1
	playerTurn = true
