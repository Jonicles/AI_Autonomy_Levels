extends Area2D

class_name DropZoneCable

@onready var truck: Truck = $".."
var charged: bool = false

func try_drop_off(cableColor, cableHeadParentNode: Area2D):
	if charged:
		return false
		
	if not truck.try_connect_cable(cableColor, cableHeadParentNode):
		return false
	
	charged = true
	cableHeadParentNode.global_position = global_position
	return true
		
