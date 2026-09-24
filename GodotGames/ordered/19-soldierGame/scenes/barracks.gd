extends Node2D

var newCharScene = preload("res://scenes/barracks_character.tscn")

var created = false

var charray = [] ##should make this dict but everything here is makeshift rn
@onready var charPoints = [$charPoint1, $charPoint2, $charPoint3, $charPoint4, $charPoint5, $charPoint6]

func _ready():
	create_character()

func _process(_delta):
	if charray.is_empty() == false:
		for charT in charray:
			if charT.clicked == true:
				charT.display_stats($Control/TableName, $Control/TableStats)
				charT.clicked = false

func create_character():
	if created == true: ## delete current
		for ID in CharacterManager.characterLedger.keys():
			CharacterManager.characterLedger.get(ID).queue_free()
		CharacterManager.characterLedger.clear()
		for charT in charray:
			charT.queue_free()
		charray.clear()
		
	## create next
	for i in range(0,6):
		var newCharStats = CharacterManager.create_new_character()
		var newChar = newCharScene.instantiate()
		newChar.baseChar = newCharStats
		add_child(newChar)
		charray.append(newChar)
		newChar.global_position = charPoints[i].global_position
	created = true

func _on_button_pressed():
	$Control/TableName.text = ""
	$Control/TableStats.text = ""
	create_character()
