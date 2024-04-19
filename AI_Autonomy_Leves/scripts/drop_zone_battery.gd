extends DropZone

var scoreValue: int = 5
var assistValue: int = 3

func try_drop_off(itemType, item):
	if itemType != acceptedItemType:
		return false
	
	var battery = item as Battery
	if battery.charges != 0:
		return false
	
	item_dropped.emit(item)
	battery.queue_free()
	return true

func add_points(scorer: CharacterController, assister: CharacterController):
	scorer.add_score(scoreValue)
	
	if assister:
		assister.add_score(assistValue)
