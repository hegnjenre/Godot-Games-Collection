extends TextureButton

func _on_pressed():
	SignalControl.battleButtonPress(self, name)
