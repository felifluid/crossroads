class_name HUD
extends Control

signal new_mesh_selected(idx: int)
signal rotate_plus_pressed
signal rotate_minus_pressed
signal delete_pressed()

@export var unlock_reqs: UnlockDB

var in_menu: bool = false

@onready var actions: HBoxContainer = $PanelContainer/Buttons/Actions
@onready var button_rotate_plus: Button = $PanelContainer/Buttons/Actions/RotatePlus
@onready var button_rotate_minus: Button = $PanelContainer/Buttons/Actions/RotateMinus
@onready var button_delete: Button = $PanelContainer/Buttons/Actions/Delete
@onready var tab_container: TabContainer = $PanelContainer/TabContainer
@onready var buildings: HBoxContainer = $PanelContainer/TabContainer/Buildings
@onready var ornaments: HBoxContainer = $PanelContainer/TabContainer/Ornaments
@onready var nature: HBoxContainer = $PanelContainer/TabContainer/Nature
@onready var unlock_menu: UnlockMenu = $UnlockMenu


func _ready() -> void:
	var counter: int = 0
	for button: Button in buildings.get_children():
		button.pressed.connect(_on_button_pressed.bind(counter))
		counter += 1
	
	#panel_container.mouse_entered.connect(_lock_placing)
	#panel_container.mouse_exited.connect(_unlock_placing)
	button_rotate_plus.pressed.connect(func(): rotate_plus_pressed.emit())
	button_rotate_minus.pressed.connect(func(): rotate_minus_pressed.emit())
	button_delete.pressed.connect(_on_button_delete_pressed)


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#_toggle_unlock_menu()


#func _toggle_unlock_menu():
	#in_menu = !in_menu
	#panel_container.visible = !panel_container.visible
	#unlock_menu.visible = !unlock_menu.visible


func init_buttons(mesh_library: MeshLibrary, mesh_library_size: int):
	for idx in unlock_reqs.reqs_list.size():
		var infos: UnlockRequirementItem = unlock_reqs.reqs_list[idx]
		
		var button: GridButton = GridButton.new()
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		button.texture_normal = infos.preview
		button.disabled = not infos.default
		
		if infos.category == "nature":
			nature.add_child(button)
		elif infos.category == "building":
			buildings.add_child(button)
		elif infos.category == "ornament":
			ornaments.add_child(button)





func _find_mesh_from_name(mesh_library: MeshLibrary, item_name: String):
	return mesh_library.find_item_by_name(item_name)



	#for idx in mesh_library_size:
		#var button := TextureButton.new()
		#button.custom_minimum_size = Vector2(50, 50)
		#button.pressed.connect(_on_button_pressed.bind(idx))
		#button.mouse_filter = Control.MOUSE_FILTER_PASS
		#button.texture_normal = mesh_library.get_item_preview(idx)
		#
		#buildings.add_child(button)


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
