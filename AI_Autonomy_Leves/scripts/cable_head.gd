class_name CableHead extends Item

@export var cableColor := GlobalEnums.CableColor.RED
@onready var cableHead: Item = $"."
@onready var resetTimer: Timer = $Timer

signal cable_connect
signal cable_disconnect

var itemType := GlobalEnums.ItemType.CABLE

#Overriden Drop method
func drop():
	print("I AM: ")
	print(cableColor)
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		resetTimer.start()
		return
	
	var zone = areas[0] as DropZoneCable
	if zone.try_drop_off(itemType, cableHead):
		if not zone.try_connection(cableColor, cableHead):
			resetTimer.start()
	else:
		resetTimer.start()

func _on_timer_timeout():
	resetTimer.stop()
	disconnect_head()

func connect_head():
	make_ungrabable()
	cable_connect.emit()

func disconnect_head():
	make_grabable()
	cable_disconnect.emit()
