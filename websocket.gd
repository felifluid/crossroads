#TODO add this script to your global variables: 
	# click Project
	# -> Project Settings
	# -> Globals 
	# -> click folder icon and select websocket.gd
	# -> click Add
# in your code, call Websocket.call_API(game_name, element, element, element) when the player has won the game
	# game_name can be any String
	# element can be "fire", "water", "earth", "air" or "mystic"
	# example: Websocket.call_API("CocainTurtleRace", "mystic", "air", "air")
# you can decide which combination of elements fits your game the best, multiple elements are also possible. 

extends Node
var websocket_url := "wss://kly6piqk82.execute-api.eu-north-1.amazonaws.com/development?client=%s&?el1=%s&?el2=%s&?el3=%s"
var socket : WebSocketPeer

func call_API(game_name : String, element1 : String, element2 : String, element3 : String) -> void:
	if (is_processing()):
		socket = WebSocketPeer.new()
		print("DEBUG: calling crossroads API")
		socket.connect_to_url(websocket_url % [game_name, element1, element2, element3])
	
func _process(delta: float) -> void:
	socket.poll()
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		print("DEBUG: API call finished")
		set_process(false)
