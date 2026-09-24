extends "res://2DAssets/Units/unit_3d.gd"

var placed = false
var leftAttackingCell = null
var rightAttackingCell = null

func setAttack():
	if placed == false and enemyOrPlayer == 0:
		var row = ((8) - selfCellTranslated[0])
		var forward = ((0) + (selfCellTranslated[1]))
		var left1 = ((0) + (selfCellTranslated[1]-1))
		var right1 = ((0) + (selfCellTranslated[1]+1))
		if left1 >= 0:
			leftAttackingCell = enemyCells.get_node(board.boardDict[row][left1][0])
			attackingCells.append(leftAttackingCell)
		if right1 <= 8:
			rightAttackingCell = enemyCells.get_node(board.boardDict[row][right1][0])
			attackingCells.append(rightAttackingCell)
		attackingCell = enemyCells.get_node(board.boardDict[row][forward][0])
		
		var attackingPoint = null
		attackingPoint = Sprite3D.new()
		if attackingPoint != null:
			enemyCells.add_child(attackingPoint)
			attackingPoint.position = attackingCell.get_position()
			attackingPoint.position.y += 0.8
			attackingPoint.scale = Vector3(10,10,1)
			attackingPoint.texture = selectedAttackingPointTexture
			attackingPoint.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
			attackingPoints.append(attackingPoint)
			attackingCells.append(attackingCell)
		for i in range (0,2):
			if i == 0 and leftAttackingCell != null:
				attackingPoint = Sprite3D.new()
				enemyCells.add_child(attackingPoint)
				attackingPoint.position = leftAttackingCell.get_position()
			elif i == 1 and rightAttackingCell != null:
				attackingPoint = Sprite3D.new()
				enemyCells.add_child(attackingPoint)
				attackingPoint.position = rightAttackingCell.get_position()
			if attackingPoint != null:
				attackingPoint.position.y += 0.8
				attackingPoint.scale = Vector3(10,10,1)
				attackingPoint.texture = selectedAttackingPointTexture
				attackingPoint.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				attackingPoints.append(attackingPoint)
		placed = true
	elif enemyOrPlayer == 1:
		var row = ((8) - selfCellTranslated[0])
		var left1 = ((0) + (selfCellTranslated[1]+1))
		var right1 = ((0) + (selfCellTranslated[1]-1))
		var leftAttackingCell = playerCells.get_node(board.boardDict[row][left1][0])
		var rightAttackingCell = playerCells.get_node(board.boardDict[row][right1][0])
		attackingCells.append(leftAttackingCell)
		attackingCells.append(rightAttackingCell)
	
	settingAttack = false
	TranslateCell.selectingTarget = false
