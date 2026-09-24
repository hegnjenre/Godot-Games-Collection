extends Node

var charID:String

@export var charName:String = ""
@export var charAge:int = 0
@export var charOrigin:String = ""
@export var charVice:String = ""          ## relates to event tags to trigger character reactions during training
@export var charExpertise:String = ""     ## one type of skill gets 1.5x xp
@export var charShortfall:String = ""     ## one type of skill gets 0.5x xp
@export var charPersonality:String = ""   ## both are based off of charPersonality

var charMorale:float = 0.0
var charMovement:float = 0.0
var charLevel:int = 0

var charSpeed:int = 0       ## all of these range from level 0 to 10
var charAim:int = 0
var charControl:int = 0
var charDiscipline:int = 0
var charMorality:int = 0

var speedProgress:float = 0.0    ## range from 0.0 to 100.0 as 'xp'
var aimProgress:float = 0.0
var controlProgress:float = 0.0
var disciplineProgress:float = 0.0
var moralityProgress:float = 0.0

@export var stats = {"morale":charMorale, "movementspeed":charMovement, "veteranlevel":charLevel}
@export var skills = {"speed":charSpeed, "aim":charAim, "control":charControl, "discipline":charDiscipline,
					  "morality":charMorality}
@export var trainingLevels = {"speed":speedProgress, "aim":aimProgress, "control":controlProgress,
							  "discipline":disciplineProgress, "morality":moralityProgress}

var charConnections = {}  
## is filled with links to other squad members and a value between 0.0 and 100.0, which increases after interaction


