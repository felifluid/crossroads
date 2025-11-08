extends Node

func _ready() -> void:
	var string = "Game" + str(randi_range(0,1000))
	$Label.text = string + " has been won. Rewards: fire, fire, mystic"
	Websocket.call_API(string, "fire", "fire", "mystic")
