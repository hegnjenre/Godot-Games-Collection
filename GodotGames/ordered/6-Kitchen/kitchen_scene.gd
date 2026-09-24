extends Node2D

var counter = preload("res://dish_spawner.tscn")

@onready var dishSpawners = get_node("dishSpawners")
@onready var tileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var counterTiles = tileMap.get_used_cells_by_id(0, 2)
	for i in range(0, len(counterTiles)):
		var newCounter = counter.instantiate()
		newCounter.position = tileMap.map_to_local(counterTiles[i])
		dishSpawners.add_child(newCounter)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
