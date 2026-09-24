extends "res://2DAssets/Units/unit_3d.gd"

var valid = true
var validE = true

func setAttack():
	attackingCells.clear()
	if board.playerTurn == true:
		targetingLabel.visible = true
		if selectedMarker != null:
			if Input.is_action_just_pressed("leftClick") and board.selectedAttackingCell != null and board.selectedAttackingCell.is_in_group("enemyCells") and selectedMarker == self:
				valid = true
				for i in range(0, 10):
					#print(str(board.selectedAttackingCell.name)[1] + " : " + str(selfCell.name)[1])
					if str(board.selectedAttackingCell.name)[1] != str(selfCell.name)[1]:
						valid = false
				for point in attackingPoints:
					if attackingPoints.size() > 0:
						point.queue_free()
				attackingPoints.clear()
				if valid == true:
					attackingCell = board.selectedAttackingCell
					attackingCells.append(attackingCell)
					for i in range((TranslateCell.translateStringName(board.selectedAttackingCell)[0]+1),(TranslateCell.translateStringName(board.selectedAttackingCell)[0])+3):
						if i < board.boardDict.size():
							#print("board: " + str(board.boardDict[i][TranslateCell.translateStringName(board.selectedAttackingCell)[1]][0]))
							attackingCell = enemyCells.get_node(board.boardDict[i][TranslateCell.translateStringName(board.selectedAttackingCell)[1]][0])
							attackingCells.append(attackingCell)
						else:
							#print("out of board")
							pass
					settingAttack = false
				
					#if attackingPointLoc != null:
						#if attackingPointLoc.get_children().size() > 0:
							#attackingPointLoc.remove_child(attackingPointLoc.get_child(1))
						
					#print(str(self) + " is attacking " + str(attackingCells))
					for attackCell in attackingCells:
						var attackingPoint = Sprite3D.new()
						attackingPointLoc = attackingCell
						attackingPoint.name = "attackingPoint"
						enemyCells.add_child(attackingPoint)
						attackingPoint.position = attackCell.get_position()
						attackingPoint.position.y += 0.8
						attackingPoint.scale = Vector3(10,10,1)
						attackingPoint.texture = selectedAttackingPointTexture
						attackingPoint.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
							
						attackingPoints.append(attackingPoint)
					TranslateCell.selectingTarget = false
				else:
					print("Archer cannot attack there. (" + str(board.selectedAttackingCell) + ")" )
					TranslateCell.selectingTarget = false
				targetingLabel.visible = false

func attack():
	if enemyOrPlayer == 1:
		for i in range(0,9):
			if validE == true:
				var columnNum = selfCellTranslated[0]
				#print(TranslateCell.translateIntoCell(str(i) + str(selfCellTranslated[1])))
				#print(board.playerBoard[i][int(selfCellTranslated[1])].size())
				if board.playerBoard[i][int(selfCellTranslated[1])].size() > 0:
					attackingCells.append(TranslateCell.translateIntoCell(str(i) + str(selfCellTranslated[1])))
					attackingCells.append(TranslateCell.translateIntoCell(str(i+1) + str(selfCellTranslated[1])))
					attackingCells.append(TranslateCell.translateIntoCell(str(i-1) + str(selfCellTranslated[1])))
					validE = false
					#print(attackingCells)
	for cell in attackingCells:
		var attackedCellIndex = TranslateCell.translateString(cell)
		if enemyGM.enemyBoard[attackedCellIndex[0]][attackedCellIndex[1]].size() > 0 and enemyOrPlayer == 0:
			var attackedUnit = enemyGM.enemyBoard[attackedCellIndex[0]][attackedCellIndex[1]][0]
			cell.get_node(attackedUnit).takeDamage(damage)
			if cell.get_node(attackedUnit).health <= 0:
				cell.get_node(attackedUnit).queue_free()
				enemyGM.enemyBoard[attackedCellIndex[0]][attackedCellIndex[1]].remove_at(0)
		elif board.playerBoard[attackedCellIndex[0]][attackedCellIndex[1]].size() > 0 and enemyOrPlayer == 1:
			var attackedUnit = board.playerBoard[attackedCellIndex[0]][attackedCellIndex[1]][0]
			attackedUnit.takeDamage(damage)
			if attackedUnit.health <= 0:
				attackedUnit.queue_free()
				board.playerBoard[attackedCellIndex[0]][attackedCellIndex[1]].remove_at(0)


