extends Node2D

var location = null

func _on_area_2d_area_entered(area):
	location = area.get_parent()
	#print(location)
