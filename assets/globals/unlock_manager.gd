extends Node


var tokens: Dictionary[String, int] = {
	"fire": 2,
	"water": 4,
	"air": 7,
	"earth": 5,
	"mystic": 2
}

#var unlocks: Dictionary[String, bool] = {
	#""
#}

var unlocks: Array[bool] = [
	false,
	true,
	false,
	false,
	true,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	true,
	true,
	false,
	false,
	false,
	false,
	true,
	false,
	false,
	true,
	false,
	false,
	false,
	]


func unlock_new_object(idx: int):
	unlocks[idx] = true



func update_tokens(game):
	tokens[game[0]] += 1
	tokens[game[1]] += 1
	tokens[game[2]] += 1
