extends Node


var unlock_db: UnlockDB = preload("res://assets/ui/unlock_menu/prelim_list.tres")

var tokens: Dictionary[String, int] = {
	"fire": 2,
	"water": 4,
	"air": 7,
	"earth": 5,
	"mystic": 2
}

#var unlocks: Dictionary[String, bool] = {
	#""
#}

var unlocks: Array[bool] = [
	]


func _ready() -> void:
	for item in unlock_db.reqs_list:
		unlocks.append(item.default)


func unlock_new_object(idx: int):
	unlocks[idx] = true


func _update_inventory():
	$Inventory/Water/Amount.text = str(tokens["water"])
	$Inventory/Fire/Amount.text = str(tokens["fire"])
	$Inventory/Earth/Amount.text = str(tokens["earth"])
	$Inventory/Air/Amount.text = str(tokens["air"])
	$Inventory/Mystic/Amount.text = str(tokens["mystic"])


func unlock_attempt(idx: int):
	if UnlockManager.unlocks[idx]:
		return
	
	print(idx, " pressed")
	var reqs = unlock_db.reqs_list[idx]
	
	var purchasable: bool = (
		reqs.fire <= tokens["fire"]
		and reqs.earth <= tokens["earth"]
		and reqs.water <= tokens["water"]
		and reqs.air <= tokens["air"]
		and reqs.mystic <= tokens["mystic"]
	)
	
	if not purchasable:
		print("not enough tokens of some sort")
		return
	print("subtracting: ", tokens["fire"], tokens["earth"], tokens["water"], tokens["air"], tokens["mystic"])
	tokens["fire"] -= reqs.fire
	tokens["earth"] -= reqs.earth
	tokens["water"] -= reqs.water
	tokens["air"] -= reqs.air
	tokens["mystic"] -= reqs.mystic
	
	UnlockManager.unlock_new_object(idx)


func update_tokens(game):
	tokens[game[0]] += 1
	tokens[game[1]] += 1
	tokens[game[2]] += 1
