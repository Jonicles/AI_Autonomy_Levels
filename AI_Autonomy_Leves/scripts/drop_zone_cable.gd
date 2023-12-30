extends Area2D

class_name DropZoneCable

@onready var truck: Truck = $".."
var charged: bool = false


func try_drop_off(cableColor):
	if charged:
		return
		
	if truck.try_connect_cable(cableColor):
		charged = true
