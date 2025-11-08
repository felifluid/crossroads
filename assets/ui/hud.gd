extends Control

signal new_mesh_selected(idx: int)


@onready var buttons: HBoxContainer = $Buttons


func _ready() -> void:
	var counter: int = 0
	for button: Button in buttons:
		button.pressed.connect(_on_button_pressed.bind(counter))


func _on_button_pressed(idx: int):
	new_mesh_selected.emit(idx)
