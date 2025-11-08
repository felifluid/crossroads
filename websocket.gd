extends Node

@export var websocket_url = "wss://kly6piqk82.execute-api.eu-north-1.amazonaws.com/development/"

var socket : WebSocketPeer
var current_state : WebSocketPeer.State = WebSocketPeer.STATE_CLOSED

func _ready() -> void:
	socket = WebSocketPeer.new()
	socket.connect_to_url(websocket_url + "?username=test_user")
	
func _process(_delta: float) -> void:
	socket.poll()
	if socket.get_ready_state() != current_state:
		current_state = socket.get_ready_state()
		print("current state: ", current_state)
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			print("message received: ", JSON.stringify(socket.get_packet().get_string_from_utf8()))
