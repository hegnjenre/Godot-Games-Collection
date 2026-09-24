extends Node2D

var preTB = preload("res://scenes/puzzles/wires/tb_wire.tscn")
var preLR = preload("res://scenes/puzzles/wires/lr_wire.tscn")
var preL = preload("res://scenes/puzzles/wires/l_wire.tscn")
var preT = preload("res://scenes/puzzles/wires/t_wire.tscn")
var preButton = preload("res://scenes/puzzles/wires/button.tscn")

var map = null

@onready var buttonContainer = $ScrollContainer/GridContainer
@onready var signalTimer = $Timer

var selected = null
var selectedType = null
var selectedButton = null
var placed = false
var mousePos = Vector2()
var mouseTile = Vector2i()
var mouseTileGlobal = Vector2()
var startWire = null
var endWire = null

var placedWires = {}
var wireList = {preTB:preload("res://sprites/puzzles/pieceTB.png"),
				preLR:preload("res://sprites/puzzles/pieceLR.png"),
				preL:preload("res://sprites/puzzles/pieceL1.png"),
				preT:preload("res://sprites/puzzles/pieceT1.png")}

func _ready():
	unload_buttons()

func start_new_puzzle():
	setup_board()

func unload_buttons():
	for wKey in wireList.keys():
		var newButton = preButton.instantiate()
		buttonContainer.add_child(newButton)
		newButton.icon = wireList.get(wKey)
		var newWirePre = wKey
		newButton.wireType = newWirePre
		newButton.controller = self
		newButton.custom_minimum_size = Vector2(192,192)
		newButton.expand_icon = true
		newButton.set_icon_alignment(HORIZONTAL_ALIGNMENT_CENTER)

func _unhandled_input(event):
	if selected != null && !placed:
		mousePos = get_global_mouse_position()
		mouseTileGlobal = Vector2(map.map_to_local(map.local_to_map(mousePos)).x - 8, map.map_to_local(map.local_to_map(mousePos)).y + 8)
		mouseTile = map.local_to_map(mousePos)
		#if selected.visible != true:
			#selected.visible = true

func on_board(tile):
	if (tile.x >= 10 && tile.x <= 19) && (tile.y >= 0 && tile.y <= 10):
		return true
	else:
		return false

func instantiate_new_wire():
	var newWire = selectedType.instantiate()
	add_child(newWire)
	if newWire.rotatable:
		newWire.rotNum = selected.rotNum-1
		if newWire.rotNum == -1:
			newWire.rotNum = 3
		if newWire.rotNum != 0:
			newWire.rotate_wire()
	newWire.set_global_position(mouseTileGlobal)
	placedWires.get_or_add(mouseTile, newWire)
	newWire.tilePos = mouseTile
	newWire.controller = self
	newWire.check_connections(map.get_surrounding_cells(mouseTile))

func place_wire():
	selected.set_global_position(get_global_mouse_position())
	if Input.is_action_just_pressed("leftClick") && on_board(mouseTile) && !map.get_cell_tile_data(mouseTile).get_custom_data("full"):
		var wire = placedWires.get(mouseTile)
		if wire == null:
			instantiate_new_wire()
		elif wire != null:
			var wireCons = wire.connections
			for con in wireCons: ## remove freed wire from other wire's connections lists
				con.connections.erase(wire)
			wire.queue_free()
			placedWires.erase(mouseTile)
			instantiate_new_wire()
	if Input.is_action_just_pressed("rightClick") && selected.rotatable:
		selected.rotate_wire()
	if Input.is_action_just_pressed("unSelect"):
		selected.queue_free()
		selected = null
		selectedButton = null

func reset_puzzle_scene():
	map.queue_free()
	map = null
	startWire = null
	endWire = null
	selected.queue_free()
	selected = null
	selectedButton = null
	placedWires.clear()

func setup_board():
	map = Global.get_puzzle().instantiate()
	add_child(map)
	startWire = map.start
	endWire = map.end
	placedWires.get_or_add(map.local_to_map(startWire.get_global_position()), startWire)
	placedWires.get_or_add(map.local_to_map(endWire.get_global_position()), endWire)

func designal_wires():
	for wKey in placedWires:
		placedWires.get(wKey).signaled = false

func _process(_delta: float) -> void:
	if selected != null && placed:
		selected = null
		placed = false
	elif selected != null && !placed:
		place_wire()

func _on_button_pressed() -> void:
	if !Global.is_puzzle_solved():
		startWire.send_signal()
		signalTimer.start()

func _on_timer_timeout() -> void:
	if Global.is_puzzle_solved():
		Global.unsolve_puzzle()
		Global.clear_puzzle()
		reset_puzzle_scene()
	else:
		designal_wires()
		print("failure")
