class_name CableHead extends Item

@export var cableColor := GlobalEnums.CableColor.RED
@export var cableLine: CableLine

@onready var cableHead: Item = $"."
@onready var resetTimer: Timer = $Timer

signal cable_connect
signal cable_disconnect

signal grabable
signal ungrabable

var itemType := GlobalEnums.ItemType.CABLE

#Overriden Drop method
func drop():
	make_grabable()
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

func immediate_drop():
	resetTimer.start()
	drop_immediately.emit()
	make_ungrabable()

func grab():
	make_ungrabable()
	grabbed_item.emit(self)
	resetTimer.stop()

func _on_timer_timeout():
	resetTimer.stop()
	disconnect_head()

func connect_head():
	make_ungrabable()
	resetTimer.stop()
	cable_connect.emit()
	cableLine.start_electrification()

func disconnect_head():
	cableLine.reset_cable()
	cable_disconnect.emit()
	
func make_grabable():
	isGrabable = true
	grabable.emit(self)

func make_ungrabable():
	isGrabable = false
	ungrabable.emit(self)
