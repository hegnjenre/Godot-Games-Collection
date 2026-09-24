extends Button

var puzzleName = ""
var controller = null

func _on_pressed() -> void:
	Global.choose_puzzle(puzzleName)
	controller.emit_puzzle_chosen()
