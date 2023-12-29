extends Item

var itemType := GlobalEnums.ItemType.CABLE

#Overriden Drop func
func drop():
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		return
	
	var zone = areas[0] as DropZone
	if zone.try_collect(itemType):
		collect()

func collect():
	queue_free()
