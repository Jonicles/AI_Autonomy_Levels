class_name BatteryPylon extends StaticBody2D

@onready var cableHeadLeft: Item =  $CableLeft
@onready var cableHeadRight: Item =  $CableRight
@onready var batteryContainer: ItemContainer = $DropZone

signal battery_insert
signal battery_removal

var startPositionLeft
var startPositionRight
var currentBattery: Battery

var isLeftHeadConnected: bool = false
var isRightHeadConnected: bool = false

func _ready():
	startPositionLeft = cableHeadLeft.global_position
	startPositionRight = cableHeadRight.global_position
	
	cableHeadLeft.make_ungrabable()
	cableHeadRight.make_ungrabable()

func insert_battery(newBattery: Battery):
	if newBattery.charges == 0:
		return
		
	currentBattery = newBattery
	newBattery.global_position = global_position
	
	currentBattery.make_ungrabable()
	
	if not isLeftHeadConnected:
		cableHeadLeft.make_grabable()
	if not isRightHeadConnected:
		cableHeadRight.make_grabable()
	
	currentBattery.grabbed_empty_battery.connect(remove_battery)
	currentBattery.no_charges_left.connect(_on_empty_battery)
	battery_insert.emit(self)
	
func _on_empty_battery(_battery):
	disable_cables()
	currentBattery.make_grabable()
	currentBattery.no_charges_left.disconnect(_on_empty_battery)
	
func remove_battery():
	if currentBattery:
		currentBattery.grabbed_empty_battery.disconnect(remove_battery)
		batteryContainer.remove_contained_item()
		currentBattery = null
		battery_removal.emit(self)

func disable_cables():
	if not isLeftHeadConnected:
		cableHeadLeft.immediate_drop()
		
	if not isRightHeadConnected:	
		cableHeadRight.immediate_drop()
	
	cableHeadLeft.make_ungrabable()
	cableHeadRight.make_ungrabable()

func _on_drop_zone_item_dropped(newBattery):
	if not currentBattery:
		insert_battery(newBattery)
		
func _on_cable_left_cable_connect():
	isLeftHeadConnected = true
	cableHeadLeft.make_ungrabable()
	currentBattery.use_charge()

func _on_cable_right_cable_connect():
	isRightHeadConnected = true	
	cableHeadRight.make_ungrabable()
	currentBattery.use_charge()

func _on_cable_left_cable_disconnect():
	cableHeadLeft.global_position = startPositionLeft
	isLeftHeadConnected = false
	if currentBattery and currentBattery.charges != 0:
		cableHeadLeft.make_grabable()

func _on_cable_right_cable_disconnect():
	cableHeadRight.global_position = startPositionRight
	isRightHeadConnected = false
	if currentBattery and currentBattery.charges != 0:
		cableHeadRight.make_grabable()
	
