extends AnimatedSprite3D

@onready var root = get_tree().get_root()
@onready var board = get_tree().get_root().get_node("board")
@onready var boardUI = get_tree().get_root().get_node("board/view/boardUI")
@onready var targetingLabel = boardUI.get_node("targetingLabel")
@onready var playerCells = get_tree().get_root().get_node("board/playerCells")
@onready var enemyCells = get_tree().get_root().get_node("board/enemyCells")
@onready var selfCellTranslated = TranslateCell.translateStringName(self.get_parent())
@onready var selfCell = self.get_parent()
@onready var unitUI = $unitUI
@onready var enemyGM = get_tree().get_root().get_node("board/enemyGM")
var selectedAttackingPointTexture = preload("res://placeholderPoint.png")

@export var setName = "null"
@export var health = 0
@onready var maxHealth = health
@export var damage = 0
var enemyOrPlayer = 0
var selecte = false
var hovered = false
var settingAttack = false
var attackingCell = null
var clicked = false
var attackingPointLoc = null
var attackingCells = []
var attackingPoints = []
var isSelected = false
var selectedMarker = null

func _ready():
	if self.setName != "archerUnit":
		setAttack()

func _process(_delta):
	if enemyOrPlayer == 0:
		if board.selectedUnit == null and board.selectedUnit != self: #check if unit is no longer under mouse
			hovered = false
		elif board.selectedUnit != null and board.selectedUnit == self:
			hovered = true
		
		#print("global" + str(TranslateCell.selectingTarget))
		#print("hovered: " + str(hovered))
		#print("settingAttack: " + str(settingAttack))
		#print("clicked: " + str(clicked))
		if Input.is_action_just_pressed("leftClick") and hovered == true and settingAttack == false and enemyOrPlayer == 0 and clicked == false and TranslateCell.selectingTarget == false:
			selectedMarker = self
			hovered = false
			isSelected = true
			clicked = true
		
		elif Input.is_action_just_pressed("leftClick") and hovered == false and settingAttack == false:
			isSelected = false #if unit is no longer under the mouse and you click then set isSelected to false
		if isSelected == true:
			for point in attackingPoints:
				point.visible = true
			unitUI.visible = true
		else:
			for point in attackingPoints:
				point.visible = false
			unitUI.visible = false
		if isSelected == true and settingAttack == true:#only if button has been pressed
			setAttack()
		clicked = false #prevents double clicking with is_action_just_pressed (its whole job is to prevent double clicking but ig i have to do it myself)
	elif enemyOrPlayer == 1:
		unitUI.visible = false

func setAttack():
	attackingCells.clear()

func takeDamage(dam):
	health -= dam
	#print(str(health) + "/" + str(maxHealth))

func attack():
	for cell in attackingCells:
		var attackedCellIndex = TranslateCell.translateStringName(cell)
		if enemyGM.enemyBoard[attackedCellIndex[0]][attackedCellIndex[1]].size() > 0 and enemyOrPlayer == 0:
			var attackedUnit = enemyGM.enemyBoard[attackedCellIndex[0]][attackedCellIndex[1]][0]
			cell.get_node(attackedUnit).takeDamage(damage)
			if cell.get_node(attackedUnit).health <= 0:
				cell.get_node(attackedUnit).queue_free()
				enemyGM.enemyBoard[attackedCellIndex[0]][attackedCellIndex[1]].remove_at(0)
		elif board.playerBoard[attackedCellIndex[0]][attackedCellIndex[1]].size() > 0 and enemyOrPlayer == 1:
			var attackedUnit = board.playerBoard[attackedCellIndex[0]][attackedCellIndex[1]][0]
			#print(attackedUnit)
			cell.get_node(attackedUnit).takeDamage(damage)#################
			if cell.get_node(attackedUnit).health <= 0:
				cell.get_node(attackedUnit).queue_free()
				board.playerBoard[attackedCellIndex[0]][attackedCellIndex[1]].remove_at(0)

func _on_attack_button_button_down():
	settingAttack = true
	TranslateCell.selectingTarget = true

