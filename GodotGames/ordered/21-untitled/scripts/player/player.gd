extends CharacterBody2D

const topSpeed = 300.0
const accRate = 0.1
const slowRate = 0.25

var maxHealth = 100
var health = maxHealth
var defense = 0

var objId = 0
var slowingDir_x = 0
var slowingDir_y = 0
var direction = Vector2()
var minTileRadius = 30
var maxTileRadius = 120

@onready var sprite = $Sprite2D
@onready var tiles = Global.get_map()

var tilesInRange = {}
var currentChunk:Node2D = null

func set_current_chunk(chunk):
	currentChunk = chunk

func _ready():
	objId = Global.add_obj(self)
	Global.set_player(self)
	## realistically a bad implementation, 
	## means player must always be loaded before enemies, 
	## for now is fine.
	Global.initialize_resources_ui($UIController)

func get_input():
	var inputDir_x = 0
	var inputDir_y = 0
	
	if Input.is_action_pressed('right'):
		inputDir_x += 1
		sprite.play("default")
		sprite.flip_h = false
	if Input.is_action_pressed('left'):
		inputDir_x -= 1
		sprite.play("default")
		sprite.flip_h = true
	if Input.is_action_pressed('down'):
		inputDir_y += 1
		sprite.play("down")
		sprite.flip_h = false
	if Input.is_action_pressed('up'):
		inputDir_y -= 1
		sprite.play("up")
		sprite.flip_h = false
	return Vector2(inputDir_x, inputDir_y)

func move(delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * topSpeed, accRate)
	else:
		velocity = velocity.lerp(Vector2.ZERO, slowRate)
	move_and_slide()

func update_tiles():
	var tile = tiles.get_cell_tile_data(tiles.local_to_map(Vector2(get_global_position().x+90, get_global_position().y+90)))
	
	#print(tile)

func _process(delta):
	move(delta)
	update_tiles()
