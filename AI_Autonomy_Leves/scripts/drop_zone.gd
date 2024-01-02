class_name DropZone extends Area2D

@export var acceptedItemType := GlobalEnums.ItemType.BATTERY
signal item_dropped

func try_drop_off(itemType, item):
	if itemType == acceptedItemType:
		item_dropped.emit(item)
		return true
	else:
		return false
