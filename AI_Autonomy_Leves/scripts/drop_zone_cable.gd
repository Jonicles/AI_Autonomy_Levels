class_name DropZoneCable extends DropZone

var truck: Truck
var charged: bool = false
var connectionPriority: float = 0
signal point_connected

func _ready():
	truck = get_parent().get_parent()

func try_connection(cableColor, cableHead: CableHead):
	if charged:
		return false
		
	if not truck.try_connect_cable(cableColor):
		return false
	
	charged = true
	truck.connect_cable(cableColor, cableHead)
	cableHead.global_position = global_position
	point_connected.emit(self)
	return true

func update_priority():
	connectionPriority += 1
