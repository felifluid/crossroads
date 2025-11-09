class_name Tooltip
extends Control


static var scene = preload("res://assets/ui/tooltip/tooltip.tscn")

static func create_tooltip(fire: int, earth: int, air: int, water: int, mystic: int):
	var tooltip = scene.instantiate()
	tooltip.find_child("Fire").get_child(1).text = str(fire)
	tooltip.find_child("Earth").get_child(1).text = str(earth)
	tooltip.find_child("Air").get_child(1).text = str(air)
	tooltip.find_child("Water").get_child(1).text = str(water)
	tooltip.find_child("Mystic").get_child(1).text = str(mystic)
	
	return tooltip
