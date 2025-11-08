class_name HUD
extends Control

signal new_mesh_selected(idx: int)


@onready var buttons: HBoxContainer = $Buttons


func _ready() -> void:
	var counter: int = 0
	for button: Button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(counter))
		button.mouse_entered.connect(_lock_placing)
		button.mouse_exited.connect(_unlock_placing)
		counter += 1


func _on_button_pressed(idx: int):
	new_mesh_selected.emit(idx)


func _lock_placing():
	GameManager.placing_locked = true


func _unlock_placing():
	GameManager.placing_locked = false
