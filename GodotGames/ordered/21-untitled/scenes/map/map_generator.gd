extends Node2D

var chunks = {}
var zeroChunk = null
var chunkScene = preload("res://scenes/map/map_chunk.tscn")
var activatedChunks = []
var pathGrid = AStarGrid2D.new()

#var chunkSiblings = {Vector2i(-288,-288):[Vector2i(-288,0), Vector2i(0,-288)],    ## top left : left and top
					 #Vector2i(0,-288):[Vector2i(-288,-288), Vector2i(288,-288)], ## top : top left and top right
					 #Vector2i(288,-288):[Vector2i(0,-288), Vector2i(288,0)],     ## top right : top and right
					 #Vector2i(288,0):[Vector2i(288,-288), Vector2i(288,288)],    ## right : top right and bottom right
					 #Vector2i(288,288):[Vector2i(288,0), Vector2i(0,288)],       ## bottom right : right and bottom
					 #Vector2i(0,288):[Vector2i(-288,288), Vector2i(288,288)],    ## bottom : bottom left and bottom right
					 #Vector2i(-288,288):[Vector2i(0,288), Vector2i(-288,0)],     ## bottom left : bottom and left
					 #Vector2i(-288,0):[Vector2i(-288,288), Vector2i(-288,-288)]} ## left : bottom left and top left

@onready var player = Global.get_player()

func create_new_chunk(width = 9, height = 9, pos = Vector2(0,0)):
	var newChunkScene = chunkScene.instantiate()
	add_child(newChunkScene)
	newChunkScene.width = width
	newChunkScene.height = height
	newChunkScene.name = "chunk" + str(pos)
	newChunkScene.set_global_position(pos)
	#newChunkScene.tileset.set_global_position(Vector2(newChunkScene.get_global_position().x - 16,newChunkScene.get_global_position().y + 16))
	return newChunkScene

func generate_full_map():
	if player != null: ## generate continued
		pass
	else: ## generate start map 5x5 square of chunks
		zeroChunk = create_new_chunk()
		chunks.get_or_add(Vector2(0,0), zeroChunk)
		generate_chunks(zeroChunk)
		zeroChunk.current = true
		Global.set_current_chunk(zeroChunk)
		for adjacentKey in zeroChunk.adjacentChunks.keys():
			var currentChunk = zeroChunk.adjacentChunks.get(adjacentKey)
			generate_chunks(currentChunk)

func generate_chunks(chunk):
	for adjacentKey in chunk.adjacentChunks.keys():
		if chunk.adjacentChunks.get(adjacentKey) == null:
			var currentPosition = chunk.get_global_position()
			var newPosition = Vector2(currentPosition.x + adjacentKey.x, currentPosition.y + adjacentKey.y)
			var newChunk = create_new_chunk(9,9,newPosition)
			chunks.get_or_add(newPosition, newChunk)
			chunk.adjacentChunks.set(adjacentKey, newChunk)
	## now have to make sure each chunk knows it has siblings, to prevent duplicates
	for adjacentKey in chunk.adjacentChunks.keys():
		var current = chunk.adjacentChunks.get(adjacentKey)
		for adjacentUpdate in current.adjacentChunks.keys():
			if chunks.get(current.to_global(adjacentUpdate), null) != null:
				## need to add existing chunk to adjacent list
				current.adjacentChunks.set(adjacentUpdate, chunks.get(current.to_global(adjacentUpdate)))
			## otherwise empty adjacent is fine because we know it's supposed to be empty

func _ready() -> void:
	generate_full_map()
	pathGrid.cell_size = Vector2(32, 32)
	pathGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	pathGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathGrid.jumping_enabled = true
	pathGrid.region = Rect2i(Vector2i(-640, -640), Vector2i(1280, 1280))
	pathGrid.update()
	Global.set_path_grid(pathGrid)
