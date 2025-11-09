class_name UnlockMenu
extends Control


@export var unlock_reqs: UnlockDB

var hovered_button: int = -1

@onready var grid_container: GridContainer = $Unlockables

func _ready() -> void:
	for i in 25:
		var button: GridButton = GridButton.new()
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		button.texture_normal = load("res://icon.svg")
		var disabled_texture = PlaceholderTexture2D.new()
		disabled_texture.size = Vector2(50, 50)
		button.texture_disabled = disabled_texture
		button.custom_minimum_size = Vector2(50, 50)
		if not UnlockManager.unlocks[i]:
			button.disabled = false
		else:
			button.disabled = true
		grid_container.add_child(button)
		button.pressed.connect(_on_button_pressed.bind(i))
		button.mouse_entered.connect(func(): hovered_button = i)
		button.mouse_exited.connect(func(): hovered_button = -1)
	
	_update_inventory()

func _update_inventory():
	var tokens = UnlockManager.tokens
	$Inventory/Water/Amount.text = str(tokens["water"])
	$Inventory/Fire/Amount.text = str(tokens["fire"])
	$Inventory/Earth/Amount.text = str(tokens["earth"])
	$Inventory/Air/Amount.text = str(tokens["air"])
	$Inventory/Mystic/Amount.text = str(tokens["mystic"])


func _on_button_pressed(idx: int):
	if UnlockManager.unlocks[idx]:
		return
	
	print(idx, " pressed")
	var button: TextureButton = grid_container.get_child(idx)
	var reqs: UnlockRequirementItem = unlock_reqs.reqs_list[idx]
	var purchasable: bool = (
		reqs.fire <= UnlockManager.tokens["fire"]
		and reqs.earth <= UnlockManager.tokens["earth"]
		and reqs.water <= UnlockManager.tokens["water"]
		and reqs.air <= UnlockManager.tokens["air"]
		and reqs.mystic <= UnlockManager.tokens["mystic"]
	)
	
	if not purchasable:
		print("not enough tokens of some sort")
		return
	
	UnlockManager.tokens["fire"] -= reqs.fire
	UnlockManager.tokens["earth"] -= reqs.earth
	UnlockManager.tokens["water"] -= reqs.water
	UnlockManager.tokens["air"] -= reqs.air
	UnlockManager.tokens["mystic"] -= reqs.mystic
	
	UnlockManager.unlock_new_object(idx)
	_update_inventory()
	button.disabled = false
