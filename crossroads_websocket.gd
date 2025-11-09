extends Node

@export var hud: HUD

@onready var websocket_url = "wss://kly6piqk82.execute-api.eu-north-1.amazonaws.com/development?client=%s&username=%s"
@onready var control = $"../Control"
@onready var text_edit = $"../Control/VBoxContainer/TextEdit"
var game_name = "crossroads"
var socket : WebSocketPeer
var current_state : WebSocketPeer.State = WebSocketPeer.STATE_CLOSED
var ping_timer := 0.0
var username = "default_user"
var payload_crossroads = {
			"action": "fetch",
			"message": {
				'game_name' : game_name,
				'username' : username
			}
		}

func _ready() -> void:
	socket = WebSocketPeer.new()
	hud.hide()
	
func connect_to_socket() -> void:
	payload_crossroads['message']['username'] = username
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
			var packet = socket.get_packet().get_string_from_utf8()
			var message = _decode(packet)
			if message == null:
				continue
			print("message received: ", JSON.stringify(message, "\t"))
			if message is Dictionary:
				_handle_message(message)

func _decode(packet):
	var message
	var json = JSON.new()
	var error = json.parse(packet)
	if error != OK:
		message = packet
		return 0
	else:
		message = json.data
	if message is String:
		message = _decode(message)
	else:
		return message
	
func _handle_message(message) -> void:
	for game in message.keys():
		UnlockManager.update_tokens(message[game])
	hud._update_inventory()

func _on_button_pressed() -> void:
	username = text_edit.text
	connect_to_socket()
	control.hide()
	hud.show()
