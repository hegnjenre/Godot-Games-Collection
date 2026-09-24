extends Node

var baseChar = preload("res://scenes/baseChar.tscn")

var characterLedger = {}

@onready var root = get_node("../root")

## want to change these to a files in order to add lots of them easier
@export var characterNames = ["Todie", "Benjem", "Crass", "Gowan", "Jun", "Hertz"]
@export var characterVices = ["Todie"]
@export var characterPersonalities = {"Todie":null}

func create_new_character(faction:String = "westBloc", newName:String = ""):
	var newChar = baseChar.instantiate()
	newChar.charID = gen_ID()
	if newName != "":
		newChar.charName = newName
	else:
		newChar.charName = characterNames[randi_range(0,5)]
	newChar.stats["morale"] = randi_range(50, 101)
	newChar.charAge = randi_range(Faction.factionTranslate.get(faction).get("MINIMUM_AGE"), Faction.factionTranslate.get(faction).get("MAXIMUM_AGE"))
	newChar.charOrigin = Faction.factionTranslate.get(faction).get("COUNTRIES")[randi_range(0, Faction.factionTranslate.get(faction).get("NUM_COUNTRIES")-1)]
	newChar.charVice = characterVices[randi_range(0,0)]
	newChar.charPersonality = "Todie" ##characterPersonalities.get()
	newChar.charExpertise = ""        ##newChar.charPersonality.EXPERT
	newChar.charShortfall = ""        ##newChar.charPersonality.SHORT
	newChar.stats["movementspeed"] = randi_range(2,5)
	
	newChar.skills["speed"] = randi_range(1,4)
	newChar.skills["aim"] = randi_range(1,4)
	newChar.skills["control"] = randi_range(1,4)
	newChar.skills["discipline"] = randi_range(1,4)
	newChar.skills["morality"] = randi_range(1,4)
	
	add_child(newChar)
	characterLedger[newChar.charID] = newChar
	return newChar

func gen_ID():
	var newID = ""
	for i in range(0, 8):
		newID += str(randi_range(0,9))
	return newID
