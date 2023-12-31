class_name ItemContainer extends DropZone

var containedItem: Item

func try_drop_off(itemType, item):
	if containedItem or itemType != acceptedItemType:
		return false
	
	containedItem = item
	item_dropped.emit(item)
	return true

func remove_contained_item():
	containedItem = null
