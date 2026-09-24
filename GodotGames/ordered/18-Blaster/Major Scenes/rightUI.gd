extends Control

var fading = false
var fade = 0.8

func _process(_delta):
	if fading == true and fade >= 0:
		fade -= 0.025
		$TimeLab.label_settings.set_font_color(Color(1,1,1,fade))
		$TimeLab.label_settings.set_outline_color(Color(0,0,0,fade))
		$Time.label_settings.set_font_color(Color(1,1,1,fade))
		$Time.label_settings.set_outline_color(Color(0,0,0,fade))
		$Add.label_settings.set_font_color(Color(1,1,1,fade))
		$Add.label_settings.set_outline_color(Color(0,0,0,fade))

