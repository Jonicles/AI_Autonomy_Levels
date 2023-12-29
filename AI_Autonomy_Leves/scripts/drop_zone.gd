extends Area2D

class_name DropZone 

@export var acceptedItemType := GlobalEnums.ItemType.BATTERY

func try_collect(itemType):
	if itemType == acceptedItemType:
		return true
	else:
		return false
