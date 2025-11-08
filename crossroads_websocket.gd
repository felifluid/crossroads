extends Node

@onready var websocket_url = "wss://kly6piqk82.execute-api.eu-north-1.amazonaws.com/development?client=%s&username=%s"
@export var game_name = "crossroads"
@export var element1 = "fire"
@export var element2 = "water"
@export var element3 = "earth"
var username = "test_user"

var payload_crossroads = {
			"action": "fetch",
			"message": {
				'game_name' : game_name,
				'username' : username
			}
		}

var payload_other = {
			"action": "unlock",
			"message": {
				'game_name' : game_name,
				'element1' : element1,
				'element2' : element2,
				'element3' : element3
			}
		}

var socket : WebSocketPeer
var current_state : WebSocketPeer.State = WebSocketPeer.STATE_CLOSED
var ping_timer := 0.0

func _ready() -> void:
	socket = WebSocketPeer.new()
	print("connecting to websocket")
	socket.connect_to_url(websocket_url % [game_name, username])
	
func _process(delta: float) -> void:
	socket.poll()
	if socket.get_ready_state() != current_state:
		current_state = socket.get_ready_state()
		print("current state: ", current_state)
		if current_state == WebSocketPeer.State.STATE_OPEN:
			print("sending fetch message")
			socket.send_text(JSON.stringify(payload_crossroads))
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count() > 0:
			print("packet arrived!")
			var packet = socket.get_packet().get_string_from_utf8()
			var json = JSON.new()
			var error = json.parse(packet)
			var message
			if error != OK:
				message = packet
			else:
				message = json.data
				print("message received: ", JSON.stringify(message, "\t"))
