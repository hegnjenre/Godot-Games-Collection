extends Node2D

@onready var cam = $Camera2D
@onready var table = $table
@onready var tv = $tv
@onready var tvButtons = $tv/tvControl
@onready var tableOptions = $table/tableControl
@onready var appleCatchScene = $tv/SubViewportContainer/SubViewport/AppleCatch
@onready var appleCatchSceneView = $tv/SubViewportContainer/SubViewport
@onready var appleCatchSceneContainer = $tv/SubViewportContainer
@onready var puzzleScene = $table/puzzleViewport/SubViewport/puzzleScene
@onready var puzzleSceneView = $table/puzzleViewport/SubViewport
@onready var puzzleSceneContainer = $table/puzzleViewport
@onready var basket = $tv/SubViewportContainer/SubViewport/AppleCatch/basket
@onready var puzzleChooseControl = $puzzleChooseControl

var zoom = false
var tvOn = false
var puzzling = false

func open_choose_ui():
	puzzleChooseControl.visible = true

func close_choose_ui():
	puzzleChooseControl.visible = false

func open_puzzle():
	tvButtons.visible = false
	tableOptions.visible = false
	tv.visible = false
	puzzleSceneContainer.visible = true
	puzzling = true
	if tvOn:
		appleCatchSceneContainer.visible = false
	puzzleScene.start_new_puzzle()

func close_puzzle():
	tvButtons.visible = true
	tableOptions.visible = true
	tv.visible = true
	if tvOn:
		appleCatchSceneContainer.visible = true
	puzzleSceneContainer.visible = false
	puzzling = false

func tv_focus(toggle):
	if toggle:
		appleCatchSceneContainer.set_global_position(Vector2(0,0))
		appleCatchSceneView.size = Vector2(1280,720)
		appleCatchSceneView.size_2d_override = Vector2(0,0)
		appleCatchSceneView.size_2d_override_stretch = false
		cam.zoom = Vector2(0.9,0.9)
		table.visible = false
		tvButtons.visible = false
		tableOptions.visible = false
		zoom = true
		basket.focused = true
	else:
		appleCatchSceneContainer.set_global_position(Vector2(448,22))
		appleCatchSceneView.size = Vector2(384,216)
		appleCatchSceneView.size_2d_override = Vector2(1280, 720)
		appleCatchSceneView.size_2d_override_stretch = true
		cam.zoom = Vector2(1,1)
		table.visible = true
		tvButtons.visible = true
		tableOptions.visible = true
		zoom = false
		basket.focused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("enter") && !zoom && tvOn:
		tv_focus(true)
	elif Input.is_action_just_pressed("enter") && zoom && tvOn:
		tv_focus(false)
	if puzzling && Global.is_puzzle_solved():
		close_puzzle()

func _on_texture_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		appleCatchSceneContainer.visible = true
		appleCatchScene.on = true
		tvOn = true
		appleCatchScene.timer.set_paused(false)
		appleCatchScene.gravChangeTimer.set_paused(false)
	else:
		appleCatchSceneContainer.visible = false
		appleCatchScene.on = false
		tvOn = false
		appleCatchScene.timer.set_paused(true)
		appleCatchScene.gravChangeTimer.set_paused(true)

func _on_texture_button_2_button_down() -> void:
	if tvOn:
		basket.direction = -1.0

func _on_texture_button_3_button_down() -> void:
	if tvOn:
		basket.direction = 1.0

func _on_texture_button_2_button_up() -> void:
	if tvOn:
		basket.direction = 0.0

func _on_texture_button_3_button_up() -> void:
	if tvOn:
		basket.direction = 0.0

func _on_puzzle_start_pressed() -> void:
	if Global.get_chosen_puzzle() != "":
		open_puzzle()
	else:
		print("no puzzle chosen!")

func _on_puzzle_choose_pressed() -> void:
	open_choose_ui()

func _on_puzzle_choose_control_puzzle_chosen() -> void:
	close_choose_ui()
