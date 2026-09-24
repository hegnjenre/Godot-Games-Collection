extends Node

var bits = 0 # player currency gained when destroying blocks
var balls = 0 # number of balls remaining
var gold = 0 # special currency
var arena = false # whether the arena is activated or not
var eod = false # whether day ended or not
var playerChar = null # global player variable

func get_playerChar():
	return playerChar

func set_playerChar(PC):
	playerChar = PC

func set_balls(num):
	balls = num

func get_balls():
	return balls

func add_bits(num):
	bits += num

func get_bits():
	return bits

func add_gold(num):
	gold += num

func get_gold():
	return gold

func arena_on():
	arena = true

func arena_off():
	arena = false

func is_arena():
	return arena

func is_end_of_day():
	return eod

func set_eod(TF):
	eod = TF

