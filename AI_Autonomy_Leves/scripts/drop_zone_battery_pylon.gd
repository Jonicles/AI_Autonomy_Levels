class_name DropZoneBatteryPylon extends DropZone



func try_drop_off(itemType, item):
	if itemType == acceptedItemType:
		item_dropped.emit(item)
		return true
	else:
		return false
