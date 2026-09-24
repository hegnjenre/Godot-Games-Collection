extends StaticBody3D

@export var itemMesh: Node3D
@export var title: String
@export var info: String

var outlined = false

@onready var itemInfo = $itemInfo
@onready var itemTitleText = $itemInfo/titleText
@onready var itemInfoText = $itemInfo/infoText

func _ready():
	itemTitleText.text = title
	itemInfoText.text = info

func _process(delta):
	if outlined == false:
		itemInfo.visible = false

func outline():
	if outlined == false:
		outlined = true
		itemInfo.visible = true

func clicked():
	outlined = false
	itemInfo.visible = false

