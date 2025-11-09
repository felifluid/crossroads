class_name HUD
extends Control

signal new_mesh_selected(idx: int, grid)
signal rotate_plus_pressed
signal rotate_minus_pressed
signal delete_pressed()

@export var unlock_reqs: UnlockDB

var in_menu: bool = false
var hovered_obj: int = 0


@onready var button_rotate_plus: Button = $Actions/RotatePlus
@onready var button_rotate_minus: Button = $Actions/RotateMinus
@onready var button_delete: Button = $Actions/Delete
@onready var tab_container: TabContainer = $PanelContainer/TabContainer
@onready var buildings: HBoxContainer = $PanelContainer/TabContainer/Buildings
@onready var ornaments: HBoxContainer = $PanelContainer/TabContainer/Ornaments
@onready var nature: HBoxContainer = $PanelContainer/TabContainer/Nature
#@onready var unlock_menu: UnlockMenu = $UnlockMenu
@onready var inventory: VBoxContainer = $Inventory


func _ready() -> void:
	_update_inventory()
	
	#tab_container.mouse_entered.connect(_lock_placing)
	#tab_container.mouse_exited.connect(_unlock_placing)
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


func init_buttons(mesh_library: MeshLibrary, grid: GridMap):
	for idx in mesh_library.get_item_list().size():
		var item_name = mesh_library.get_item_name(idx)
		var infos: UnlockRequirementItem = _find_infos_from_name(item_name)
		var i = unlock_reqs.reqs_list.find(infos)
		if not infos:
			print("didnt find infos")
			continue
		
		var button: GridButton = GridButton.new()
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		button.texture_normal = infos.preview
		#button.disabled = not infos.default
		button.custom_minimum_size = Vector2(50, 50)
		#button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.pressed.connect(_on_button_pressed.bind(idx, grid, i))
		button.mouse_entered.connect(func(): hovered_obj = i)
		button.mouse_exited.connect(func(): hovered_obj = -1)
		
		if infos.category == "nature":
			nature.add_child(button)
		elif infos.category == "building":
			buildings.add_child(button)
		elif infos.category == "ornament":
			ornaments.add_child(button)


func _find_infos_from_name(item_name: String):
	print("searching for ", item_name)
	
	for item in unlock_reqs.reqs_list:
		if item.item_name == item_name:
			return item
	
	print("couldnt find item")

	#for idx in mesh_library_size:
		#var button := TextureButton.new()
		#button.custom_minimum_size = Vector2(50, 50)
		#button.pressed.connect(_on_button_pressed.bind(idx))
		#button.mouse_filter = Control.MOUSE_FILTER_PASS
		#button.texture_normal = mesh_library.get_item_preview(idx)
		#
		#buildings.add_child(button)


func _on_button_pressed(idx: int, grid: GridMap, total_idx: int):
	if UnlockManager.unlocks[total_idx]:
		print("emitting")
		new_mesh_selected.emit(idx, grid)
	else:
		print("attempting")
		UnlockManager.unlock_attempt(total_idx)
		_update_inventory()


func _update_inventory():
	inventory.get_node("Water/Amount").text = str(UnlockManager.tokens["water"])
	inventory.get_node("Fire/Amount").text = str(UnlockManager.tokens["fire"])
	inventory.get_node("Earth/Amount").text = str(UnlockManager.tokens["earth"])
	inventory.get_node("Air/Amount").text = str(UnlockManager.tokens["air"])
	inventory.get_node("Mystic/Amount").text = str(UnlockManager.tokens["mystic"])


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
