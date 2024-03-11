class_name DropZoneCable extends DropZone

var truck: Truck
var charged: bool = false
var connectionPriority: float = 0

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
	return true

func update_priority():
	connectionPriority += 1
	print("priority updated for:")
	print(self)
	print(connectionPriority)
