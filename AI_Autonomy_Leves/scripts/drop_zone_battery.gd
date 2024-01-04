extends DropZone

func try_drop_off(itemType, item):
	if itemType != acceptedItemType:
		return false
	
	var battery = item as Battery
	if battery.charges != 0:
		return false
	
	item_dropped.emit(item)
	battery.queue_free()
	return true
