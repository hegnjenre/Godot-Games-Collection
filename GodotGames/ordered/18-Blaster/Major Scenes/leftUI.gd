extends Control

@onready var currentGold = Global.get_gold()
@onready var animator = $goldMove

var fading = false
var fade = 0.8

func _process(_delta):
	if fading == true and fade >= 0:
		fade -= 0.025
		$Bits.label_settings.set_font_color(Color(1,1,1,fade))
		$Bits.label_settings.set_outline_color(Color(0,0,0,fade))
		$Balls.label_settings.set_font_color(Color(1,1,1,fade))
		$Balls.label_settings.set_outline_color(Color(0,0,0,fade))
		$Gold.label_settings.set_font_color(Color(1,1,1,fade))
		$Gold.label_settings.set_outline_color(Color(0,0,0,fade))
	
	$Bits.text = ("Total Bits: " + str(Global.get_bits()))
	$Balls.text = ("Total Balls: " + str(Global.get_balls()))
	$Gold.text = ("Gold: " + str(Global.get_gold()))
	
	if currentGold < Global.get_gold():
		currentGold = Global.get_gold()
		animator.play("goldMove")
