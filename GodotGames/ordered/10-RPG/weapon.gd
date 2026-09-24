extends "res://equipable.gd"

var attacks = [] # str type names of different types of attacks - each has it's own name, animation and damage dice
var attackAnims = {} # animation names stored here.
var damageDice = {} # str type variables placed within ("D12", "D6", etc)

