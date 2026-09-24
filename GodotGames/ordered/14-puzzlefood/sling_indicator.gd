extends Line2D

@onready var mouse = get_parent().get_parent().get_node("mousePointer")

var origin = null

func _ready():
	pass

func _process(_delta):
	origin = mouse.selected
	
	if origin != null:
		drawArch()
	else:
		pass

func drawArch():
	pass
