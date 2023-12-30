extends Item

var itemType := GlobalEnums.ItemType.MONEY

#Overriden Drop func
func drop():
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		return
	
	var zone = areas[0] as DropZone
	zone.try_drop_off(itemType)
