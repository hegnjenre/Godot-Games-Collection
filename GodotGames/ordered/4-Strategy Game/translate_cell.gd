extends Node

var selectingTarget = false #not for translating just for global variable, preventing clicking other units while setting attack
var charDict = {"A":0,
				"B":1,
				"C":2,
				"D":3,
				"E":4,
				"F":5,
				"G":6,
				"H":7,
				"I":8}

var indexDict = {0:"A",
				1:"B",
				2:"C",
				3:"D",
				4:"E",
				5:"F",
				6:"G",
				7:"H",
				8:"I"}

func translateString(cell):
	var cellIndex1 = charDict.get(str(cell)[0])
	var cellIndex2 = int(str(cell)[1]) - 1
	var cellIndexes = [cellIndex1, cellIndex2]
	
	return cellIndexes

func translateStringName(cell):
	var cellIndex1 = charDict.get(str(cell.name)[0])
	var cellIndex2 = int(str(cell.name)[1]) - 1
	var cellIndexes = [cellIndex1, cellIndex2]
	
	return cellIndexes

func translateIntoCell(indexString):
	var cellIndex1 = indexDict.get(int(indexString[0]))
	var cellIndex2 = int(indexString[1]) + 1
	var cellName = cellIndex1 + str(cellIndex2)
	
	return cellName
