extends "res://Prop.gd"

@onready var infoCon = $infoContainer
@onready var title = $infoContainer/title
@onready var info = $infoContainer/info

func _ready():
	object = $sign
	infoCon.visible = false
	title.text = objectTitle
	info.text = objectInfo

func _process(_delta):
	if Input.is_action_just_pressed("interact") and display == false and interactable == true:
		infoCon.visible = true
		display = true
	elif Input.is_action_just_pressed("interact") and display == true:
		infoCon.visible = false
		display = false
	
	if interactable == false:
		infoCon.visible = false
