extends Control


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
	
