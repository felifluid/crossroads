class_name HUD
extends Control

signal new_mesh_selected(idx: int)
signal rotate_plus_pressed
signal rotate_minus_pressed
signal delete_pressed()

@onready var buildings: HBoxContainer = $PanelContainer/Buttons/Buildings
@onready var actions: HBoxContainer = $PanelContainer/Buttons/Actions
@onready var button_rotate_plus: Button = $PanelContainer/Buttons/Actions/RotatePlus
@onready var button_rotate_minus: Button = $PanelContainer/Buttons/Actions/RotateMinus
@onready var button_delete: Button = $PanelContainer/Buttons/Actions/Delete
@onready var panel_container: PanelContainer = $PanelContainer


func _ready() -> void:
	var counter: int = 0
	for button: Button in buildings.get_children():
		button.pressed.connect(_on_button_pressed.bind(counter))
		counter += 1
	
	panel_container.mouse_entered.connect(_lock_placing)
	panel_container.mouse_exited.connect(_unlock_placing)
	button_rotate_plus.pressed.connect(func(): rotate_plus_pressed.emit())
	button_rotate_minus.pressed.connect(func(): rotate_minus_pressed.emit())
	button_delete.pressed.connect(_on_button_delete_pressed)


func init_buttons(mesh_library: MeshLibrary, mesh_library_size: int):
	for idx in mesh_library_size:
		var button := TextureButton.new()
		button.custom_minimum_size = Vector2(50, 50)
		button.pressed.connect(_on_button_pressed.bind(idx))
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.texture_normal = mesh_library.get_item_preview(idx)
		
		buildings.add_child(button)


func _on_button_pressed(idx: int):
	new_mesh_selected.emit(idx)


func _lock_placing():
	print("locking")
	GameManager.placing_locked = true


func _unlock_placing():
	print("unlocking")
	GameManager.placing_locked = false


func _on_button_delete_pressed():
	if button_delete.modulate == Color.WHITE:
		button_delete.modulate = Color.RED
	else:
		button_delete.modulate = Color.WHITE
	
	delete_pressed.emit()
