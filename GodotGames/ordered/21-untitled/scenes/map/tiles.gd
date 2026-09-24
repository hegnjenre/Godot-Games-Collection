extends TileMapLayer

var objId = 0

@onready var player = Global.get_player()
@onready var chunk = get_parent()
var tileMap = null

func _ready():
	objId = Global.add_obj(self)

func _process(_delta : float) -> void:
	if player == null:
		tileMap = get_used_cells()
		player = Global.get_player()
	if chunk.activated and chunk.debug == true && false:
		for cell in get_used_cells():
			if player.tilesInRange.get(to_global(map_to_local(cell)), null) != null:
				print(cell)
	elif chunk.debug == false:
		pass
