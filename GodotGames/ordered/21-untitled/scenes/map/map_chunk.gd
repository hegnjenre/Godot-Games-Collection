extends Node2D

var adjacentChunks = {Vector2(-288,-288):null, ## top left
					  Vector2(0,-288):null,    ## top
					  Vector2(288,-288):null,  ## top right
					  Vector2(288,0):null,     ## right
					  Vector2(288,288):null,   ## bottom right
					  Vector2(0,288):null,     ## bottom
					  Vector2(-288,288):null,  ## bottom left
					  Vector2(-288,0):null}    ## left

var current = false
var activated = false

@export var width = 9
@export var height = 9

@export var debug = false
var debugTagSettings = preload("res://scenes/map/debugtext.tres")

@onready var tileset = $tiles
@onready var player = Global.get_player()
@onready var generator = get_parent()

func generate_tile_map():
	for row in range(0, width):
		for column in range(0, height):
			var randTile = randi_range(2, 10)
			if debug:
				var debugTag = Label.new()
				debugTag.name = ("(" + str(row) + "," + str(column) + ")")
				debugTag.label_settings = debugTagSettings
				self.add_child(debugTag)
				debugTag.set_global_position(Vector2(tileset.map_to_local(Vector2i(row, column)).x - 12, tileset.map_to_local(Vector2i(row, column)).y - 8))
				debugTag.text = (("(" + str(row) + "," + str(column) + "): " + str(randTile)))
			tileset.set_cell(Vector2i(row, column), 0, Vector2i(randTile, 0))

func _ready() -> void:
	generate_tile_map()

func _process(_delta: float) -> void:
	if player == null:
		player = Global.get_player()
	if current and !activated:
		activated = true
	if activated && player != null:
		for cell in tileset.get_used_cells():
			var localCell = to_global(tileset.map_to_local(cell))
			var cellOffTL = Vector2(localCell.x - 16, localCell.y - 16)
			var cellOffTR = Vector2(localCell.x + 16, localCell.y - 16)
			var cellOffBL = Vector2(localCell.x - 16, localCell.y + 16)
			var cellOffBR = Vector2(localCell.x + 16, localCell.y + 16)
			var cellOffsets = [cellOffTL,cellOffTR,cellOffBL,cellOffBR]
			var outside = true
			for cellOffset in cellOffsets:
				if cellOffset.distance_to(player.get_global_position()) > player.minTileRadius && cellOffset.distance_to(player.get_global_position()) < player.maxTileRadius:
					if player.tilesInRange.get(localCell, null) == null: #prevent constant update as best as possible
						player.tilesInRange.get_or_add(localCell, cell) ## IN RANGE
					outside = false
			if outside:
				if player.tilesInRange.get(localCell, null) != null:
					player.tilesInRange.erase(localCell) ## OUT OF RANGE

func activate_siblings():
		if !generator.activatedChunks.is_empty():
			for chunk in generator.activatedChunks:
				chunk.activated = false
				if chunk.current == true:
					chunk.current = false
			generator.activatedChunks.clear()
		for adjacentKey in adjacentChunks.keys():
			if adjacentChunks.get(adjacentKey) != null:
				adjacentChunks.get(adjacentKey).activated = true
				generator.activatedChunks.append(adjacentChunks.get(adjacentKey))

func _on_chunk_area_body_entered(body: Node2D) -> void:
	if body == player && Global.get_current_chunk() == null:
		#print("entered chunk " + self.name)
		Global.set_current_chunk(self)
		player.currentChunk = self
		activate_siblings()
		current = true
		activated = true
		generator.activatedChunks.append(self)

func _on_chunk_area_body_exited(body: Node2D) -> void:
	if body == player && Global.get_current_chunk() != null:
		#print("left chunk " + self.name)
		Global.clear_current_chunk()

func _on_chunk_area_mouse_entered() -> void:
	if Global.get_current_mouse_chunk() == null:
		#print("mouse enter " + str(self.name))
		Global.clear_current_mouse_chunk()
		Global.set_current_mouse_chunk(self)

func _on_chunk_area_mouse_exited() -> void:
	if Global.get_current_mouse_chunk() != null:
		pass
