extends Node2D

var resourcesQueued = 0
var connected = false
var sendTimes = []
var paths = []
var gridRegion = null
var refreshGrid = false
var debugRect = null

@onready var sending = $sending  ## the nodes connecting the line from and to
@onready var recieving = [$recieving]
@onready var pathsNode = $paths
@onready var pathGrid = Global.get_path_grid()

@export var fromNode: Node = null ## tracks the building nodes that the channel comes from and goes to
@export var toNodes : Array[Node] = []
@export var connectingChannel : Node = null
@export var connectedChannels : Array[Node] = []
@export var resource = -1
@export var resourcesMax = 50

func send():
	if connectingChannel == null:
		resourcesQueued += 1
	else:
		connectingChannel.resourcesQueued += 1

func recieve():
	if resourcesQueued >= 1:
		resourcesQueued -= 1
	else:
		return -1

func build_channel(startNode:Node, endNode:Node):
	#if startNode.get_global_position().y > 0:
		#pathGrid.offset = Vector2(0, 16)
	#elif startNode.get_global_position().y < 0:
		#pathGrid.offset = Vector2(0, -16)
	pathGrid.update()
	var newPath = pathGrid.get_point_path(startNode.get_global_position()/32, endNode.get_global_position()/32)
	print(newPath)
	var newLine = Line2D.new()
	newLine.name = str(startNode.get_global_position()) + " to " + str(endNode.get_global_position())
	newPath.insert(0, startNode.get_global_position())
	newPath.append(endNode.get_global_position())
	newLine.points = newPath
	newLine.width = 3
	pathsNode.add_child(newLine)
	paths.append(newPath)

func connectSending():
	sending.set_global_position(fromNode.outputPoint.get_global_position())
	fromNode.set_output_channel(self)

func connectRecieving():
		var i = 0
		var startingSTs = sendTimes.size() ## prevent adding to sendTimes form screwing up the loop
		for toNode in toNodes:
			if startingSTs <= i: ## we know that we are at the new toNodes
				if toNode.inputChannel == null: ## only channel to this point
					if recieving.size() <= i:
						var newRecieving = Node2D.new()
						add_child(newRecieving)
						recieving.append(newRecieving)
						newRecieving.set_global_position(toNode.inputPoint.get_global_position())
					else:
						recieving[i].set_global_position(toNode.inputPoint.get_global_position())
					sendTimes.append(abs((fromNode.get_global_position().distance_to(toNode.get_global_position())/64)))
					toNode.prodTimer.wait_time += sendTimes[i]
					toNode.set_input_channel(self)
				else: ## connect to other channel
					toNode.inputChannel.connect_channel(self)
					connectingChannel = toNode.inputChannel
			i += 1

func connect_channel(channel):
	connectedChannels.append(channel)
	resourcesQueued += channel.resourcesQueued
	channel.resourcesQueued = 0

func killChannel():
	if connectingChannel != null:
		connectingChannel.connectedChannels.erase(self)
		connectingChannel = null
	fromNode.outputChannel = null
	fromNode = null
	for node in toNodes:
		node.inputChannel = null
	toNodes.clear()
	self.queue_free()

#func change_grid_size(start, end):
	#var pos = Vector2()
	#var posX = 0
	#var posY = 0
	#var size = 0
	#if start.y < end.y:
		#posY = start.y-48
	#else:
		#posY = end.y-48
	#if start.x < end.x:
		#print("start on left")
		#posX = start.x-16
		#pos = Vector2(posX, posY)
		#size = start.distance_to(end)+72
		### this is a mathy pain in my ass, this should cover enough area and works for now
		#gridRegion = Rect2i(pos, Vector2(size, size))
		#refreshGrid = true
	#else:
		#print("start on right")
		#posX = end.x-16
		#pos = Vector2(posX, posY)
		#size = start.distance_to(end)+72
		### this is a mathy pain in my ass, this should cover enough area and works for now
		#gridRegion = Rect2i(pos, Vector2(size, size))
		#refreshGrid = true

func _ready() -> void:
	connected = true
	connectSending()
	connectRecieving()

#func _process(_delta: float) -> void:
	#if refreshGrid:
		#print(gridRegion)
		#pathGrid.region = gridRegion
		#pathGrid.update()
		#refreshGrid = false
