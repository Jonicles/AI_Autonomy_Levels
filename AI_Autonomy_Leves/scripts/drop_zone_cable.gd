class_name DropZoneCable extends DropZone

@onready var truck: Truck = $".."
var charged: bool = false

func try_connection(cableColor, cableHead: CableHead):
	if charged:
		return false
		
	if not truck.try_connect_cable(cableColor, cableHead):
		return false
	
	cableHead.global_position = global_position
	charged = true
	return true
