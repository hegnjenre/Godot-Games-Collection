extends "res://2DAssets/Units/unit_3d.gd"

var placed = false

func setAttack():
	attackingCells.clear()
	
	#if attackingPointLoc != null:
		#if attackingPointLoc.get_children().size() > 0:
			#attackingPointLoc.remove_child(attackingPointLoc.get_child(1))
	
	if placed == false and enemyOrPlayer == 0:
		for i in range(0, 9):
			var attackingPoint = Sprite3D.new()
			attackingCell = enemyCells.get_node(board.boardDict[i][selfCellTranslated[1]][0])
			attackingPointLoc = attackingCell
			enemyCells.add_child(attackingPoint)
			attackingPoint.position = attackingCell.get_position()
			attackingPoint.position.y += 0.8
			attackingPoint.scale = Vector3(10,10,1)
			attackingPoint.texture = selectedAttackingPointTexture
			attackingPoint.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
			attackingCells.append(attackingCell)
			attackingPoints.append(attackingPoint)
		placed = true
	elif enemyOrPlayer == 1:
		for i in range(0, 9):
			attackingCell = playerCells.get_node(board.boardDict[i][selfCellTranslated[1]][0])
			attackingCells.append(attackingCell)
	settingAttack = false
	TranslateCell.selectingTarget = false


