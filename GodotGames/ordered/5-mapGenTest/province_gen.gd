@tool
extends Node2D

var image = preload("res://amogus.png")
var polygon = Polygon2D.new()
var polyArray = null

func _ready():
	var bitmap = image
	#var boopbap = bitmap.convert_to_image()
	#boopbap = ImageTexture.create_from_image(boopbap)
	#var newSprite = Sprite2D.new()
	#self.add_child(newSprite)
	#newSprite.set_texture(boopbap)
	var rect = Rect2(0, 0, 995, 1097)
	polyArray = bitmap.opaque_to_polygons(rect, 0.3)
	polygon.set_polygons(polyArray)
	#for i in range(0, polyArray.size()):
		#var newPolygon = Polygon2D.new()
		#newPolygon.name = "newPolygon" + str(i)
		#self.add_child(newPolygon)
		#newPolygon.set_polygon(polygon.polygons[i])

func _draw():
	var white : Color = Color.WHITE
	
	for polyBite in polyArray:
		draw_polygon(polyBite, [white])
		
		
