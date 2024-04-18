class_name CableHead extends Item

@export var cableColor := GlobalEnums.CableColor.RED
@export var cableLine: CableLine

@onready var cableHead: Item = $"."
@onready var resetTimer: Timer = $ResetTimer
@onready var assistTimer: Timer = $AssistTimer

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
		unsuccesful_drop()
		return
	
	var zone = areas[0] as DropZoneCable
	if zone.try_drop_off(itemType, cableHead):
		if not zone.try_connection(cableColor, cableHead):
			unsuccesful_drop()
			resetTimer.start()
		else:
			# This is a succesful drop off
			assistTimer.stop()
			zone.add_points(currentHolder, previousHolder)
			currentHolder = null
			previousHolder = null
	else:
		unsuccesful_drop()
		resetTimer.start()

func unsuccesful_drop():
	assistTimer.start()
	previousHolder = currentHolder
	currentHolder = null

func grab(character: CharacterController):
	currentHolder = character
	if currentHolder == previousHolder:
		previousHolder = null
	
	make_ungrabable()
	grabbed_item.emit(self)
	resetTimer.stop()

func immediate_drop():
	if not currentHolder:
		return
		
	currentHolder.remove_item()
	currentHolder = null
	previousHolder = null
	assistTimer.stop()
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
	
func _on_assist_timer_timeout():
	previousHolder = null
	print("Previous holder is now reset")

func _on_reset_timer_timeout():
	resetTimer.stop()
	disconnect_head()
