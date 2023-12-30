extends Item

@export var cableColor := GlobalEnums.CableColor.RED
var itemType := GlobalEnums.ItemType.CABLE

#Overriden Drop func
func drop():
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		return
	
	var zone = areas[0] as DropZoneCable
	zone.try_drop_off(cableColor)
