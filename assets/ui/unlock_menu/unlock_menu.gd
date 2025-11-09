class_name UnlockMenu
extends Control


@export var unlock_reqs: UnlockDB

@onready var grid_container: GridContainer = $Unlockables

func _ready() -> void:
	for i in 25:
		var button: TextureButton = TextureButton.new()
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		button.texture_normal = load("res://icon.svg")
		var disabled_texture = PlaceholderTexture2D.new()
		disabled_texture.size = Vector2(50, 50)
		button.texture_disabled = disabled_texture
		button.custom_minimum_size = Vector2(50, 50)
		if not UnlockManager.unlocks[i]:
			button.disabled = true
		grid_container.add_child(button)
		button.pressed.connect(_on_button_pressed.bind(i))


func _on_button_pressed(idx: int):
	print(idx, " pressed")
	var button = grid_container.get_child(idx)
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
	
