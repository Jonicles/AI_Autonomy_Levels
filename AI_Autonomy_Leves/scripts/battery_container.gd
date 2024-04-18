class_name BatteryContainer extends ItemContainer

var scoreValue: int = 5
var assistValue: int = 1

func try_drop_off(itemType, item):
	if containedItem or itemType != acceptedItemType:
		return false
		
	var battery = item as Battery
	if battery.charges == 0:
		return false
		
	containedItem = item
	item_dropped.emit(item)
	return true

func remove_contained_item():
	containedItem = null

func add_points(scorer: CharacterController, assister: CharacterController):
	scorer.add_score(scoreValue)
	
	if assister:
		assister.add_score(assistValue)
