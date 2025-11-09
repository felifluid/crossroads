class_name GridButton
extends TextureButton


@onready var hud: HUD = get_parent().get_parent().get_parent().get_parent()


func _make_custom_tooltip(_for_text: String) -> Object:
	if hud.hovered_obj == -1 or UnlockManager.unlocks[hud.hovered_obj]:
		print("exiting for ", hud.hovered_obj)
		return null
	var reqs = hud.unlock_reqs.reqs_list[hud.hovered_obj]
	var tooltip = Tooltip.create_tooltip(reqs.fire, reqs.earth, reqs.air, reqs.water, reqs.mystic)
	
	return tooltip
