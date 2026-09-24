extends CharacterBody2D

@onready var root = get_tree().get_root()
@onready var board = get_tree().get_root().get_node("board")
@onready var boardUI = board.get_node("view/boardUI")
@onready var playerCells = get_tree().get_root().get_node("board/playerCells")

@export var setName = "unit"
@export var price = 0
@export var summonChance = 0.0
var clicked = false
var justClicked = false #i hate this
var removed = false
var counterParts = {"soldierUnit":preload("res://2DAssets/Units/Human/Soldier/soldier_unit_3d.tscn"),
					"archerUnit":preload("res://2DAssets/Units/Human/Archer/archer_unit_3d.tscn"),
					"warriorUnit":preload("res://2DAssets/Units/Human/Warrior/warrior_unit_3d.tscn")
					}

func _on_mouse_entered():
	if Input.is_action_just_pressed("leftClick") and clicked == false:
		justClicked = true
		clicked = true

func _process(_delta):
	if clicked == true:
		if removed == false:
			var index = 0
			for i in range(0, boardUI.unitRosterList.size()-1):
				if boardUI.unitRosterList[i] == self:
					index = i
			print(boardUI.unitRosterList)
			boardUI.unitRosterList.remove_at(index)
			print(boardUI.unitRosterList)
			removed = true
		self.scale = Vector2(0.2,0.2)
		self.global_position.y = (get_viewport().get_mouse_position().y + 20)
		self.global_position.x = (get_viewport().get_mouse_position().x + 20)
	
	if Input.is_action_just_pressed("leftClick") and clicked == true:
		if board.selectedCell != null and board.selectedCell.is_in_group("playerCells") and clicked == true:
			var translatedCells  = TranslateCell.translateStringName(board.selectedCell)
			var isUsed = board.playerBoard[(translatedCells[0])][(translatedCells[1])].size()
			if isUsed < 1:
				var instUnit = counterParts.get(setName).instantiate()
				board.selectedCell.add_child(instUnit)
				board.playerBoard[(translatedCells[0])][(translatedCells[1])].append(instUnit)
				instUnit.name = setName
				instUnit.position.y += 1.5
				instUnit.scale = Vector3(1.45,1.45,1)
				self.queue_free()
				clicked = false
		elif (board.selectedCell == null or board.selectedCell.is_in_group("playerCells") == false) and justClicked == false:
			print("Cannot place unit there!")
		justClicked = false
	
