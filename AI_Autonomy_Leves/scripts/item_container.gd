class_name ItemContainer extends DropZone

var containedItem: Item

func try_drop_off(itemType, item):
	if not containedItem and itemType == acceptedItemType:
		containedItem = item
		item_dropped.emit(item)
		return true
	else:
		return false

func remove_contained_item():
	pass
