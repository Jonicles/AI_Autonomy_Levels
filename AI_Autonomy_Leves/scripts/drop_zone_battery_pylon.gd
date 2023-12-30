extends Area2D

class_name DropZoneBatteryPylon 

@export var acceptedItemType := GlobalEnums.ItemType.BATTERY
var leftCableHead: Item
var rightCableHead: Item

func try_drop_off(itemType):
	if itemType == acceptedItemType:
		return true
	else:
		return false
