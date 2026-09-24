extends Node2D

var baseChar:Node = null ## on instantiation of a character to assign the actual character stats

var hovered = false
var clicked = false

func _ready():
	$Label.text = baseChar.charName

func _unhandled_input(event):
	if hovered == true and event.is_action_pressed("leftclick"):
		##print("clicked")
		clicked = true
		hovered = false

func display_stats(nameBox, statsBox):
	nameBox.text = ""
	statsBox.text = ""
	
	nameBox.text = baseChar.charName
	statsBox.text = ("Age: " + str(baseChar.charAge) + "\nOrigin: " + baseChar.charOrigin)
	for key in baseChar.stats.keys():
		statsBox.text = (statsBox.text + "\n" + Global.translate.get(key) + ": " + str(baseChar.stats.get(key)))
	statsBox.text += "\n" 
	for key in baseChar.skills.keys():
		statsBox.text = (statsBox.text + "\n" + Global.translate.get(key) + ": " + str(baseChar.skills.get(key)))

func _on_area_2d_mouse_entered():
	hovered = true

func _on_area_2d_mouse_exited():
	hovered = false
