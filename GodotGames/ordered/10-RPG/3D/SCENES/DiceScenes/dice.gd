extends RigidBody3D

@onready var normals = [get_node("1"), get_node("2"), get_node("3"), get_node("4"), get_node("5"), get_node("6")]

var opposites = {"1":6,
				 "2":5,
				 "3":4,
				 "4":3,
				 "5":2,
				 "6":1}

var isMoving = false
