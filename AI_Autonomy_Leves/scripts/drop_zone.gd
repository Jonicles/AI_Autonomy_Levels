class_name DropZone extends Area2D

@export var acceptedItemType := GlobalEnums.ItemType.BATTERY
signal item_dropped

func try_drop_off(itemType, item):
	if itemType != acceptedItemType:
		return false
	
	item_dropped.emit(item)
	return true
	
func add_points(scorer: CharacterController, assister: CharacterController):
	pass
