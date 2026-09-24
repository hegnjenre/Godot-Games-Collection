extends Node

func battleButtonPress(button, attackType):
	var temp = button
	var topParent = temp.get_parent()
	while topParent.name != "BattleScene":
		temp = topParent
		topParent = temp.get_parent()
	var currentChar = topParent.currentChar
	currentChar.doAttack(attackType)
