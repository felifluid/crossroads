class_name GridButton
extends TextureButton


@onready var unlock_menu: UnlockMenu = get_parent().get_parent()


func _make_custom_tooltip(_for_text: String) -> Object:
	
	if unlock_menu.hovered_button == -1:
		return null
	var reqs = unlock_menu.unlock_reqs.reqs_list[unlock_menu.hovered_button]
	var tooltip = Tooltip.create_tooltip(reqs.fire, reqs.earth, reqs.air, reqs.water, reqs.mystic)
	
	return tooltip
