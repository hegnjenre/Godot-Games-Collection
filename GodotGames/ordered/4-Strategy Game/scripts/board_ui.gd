extends Control

@onready var soldierUnit = preload("res://2DAssets/Units/Human/Soldier/soldier_unit.tscn")
@onready var archerUnit = preload("res://2DAssets/Units/Human/Archer/archer_unit.tscn")
@onready var warriorUnit = preload("res://2DAssets/Units/Human/Warrior/warrior_unit.tscn")

@onready var playerCells = get_tree().get_root().get_node("board/playerCells")
@onready var enemyCells = get_tree().get_root().get_node("board/enemyCells")
@onready var board = get_tree().get_root().get_node("board")
@onready var roster = $unitRoster
@onready var waveInfo = $waveInfo
@onready var enemyGM = get_tree().get_root().get_node("board/enemyGM")
@onready var mouse = get_viewport().get_mouse_position()

var buttonPos = Vector2(60,70)
var unitRosterList = []

var counterParts = {"soldierUnit":preload("res://2DAssets/Units/Human/Soldier/soldier_unit.tscn"),
					"archerUnit":preload("res://2DAssets/Units/Human/Archer/archer_unit.tscn"),
					"warriorUnit":preload("res://2DAssets/Units/Human/Warrior/warrior_unit.tscn")
					}

func restockUnitList():
	clearUnitList()
	buttonPos = Vector2(60,110)
	var rowed = false
	for x in range(0, 8):
		var randUnit = randi_range(0, PlayerStats.currentUnitDeck.size()-1)
		var newButton = counterParts.get(PlayerStats.currentUnitDeck[randUnit]).instantiate() #rather tahn turns i want to do it like start wave and then it just goes until end
		roster.add_child(newButton)
		newButton.scale = Vector2(0.5,0.5)
		if x <= 3:
			buttonPos.x = 60
		else:
			buttonPos.x = 160
			if rowed == false:
				buttonPos.y = 110
				rowed = true
		newButton.position.x += buttonPos.x
		newButton.position.y += buttonPos.y
		buttonPos.y += 128
		unitRosterList.append(newButton)
	#print(unitRosterList)

func clearUnitList():
	for unit in unitRosterList:
		unit.queue_free()
	unitRosterList.clear()

func _physics_process(_delta):
	waveInfo.text = "Wave: " + str(enemyGM.wave+1)

func _on_button_pressed():
	board.playerTurn = false
	
	for row in range(0,8):
		for column in range(0,8):
			var columnChars = str(8-row) + str(column)
			var columnCharsTranslated = TranslateCell.translateIntoCell(columnChars)
			if playerCells.get_node(columnCharsTranslated) and board.playerBoard[column][row].size() > 0:
				board.playerBoard[column][row][0].attack()
