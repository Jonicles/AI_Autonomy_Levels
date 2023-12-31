extends StaticBody2D

@onready var cableHeadLeft: Item =  $CableLeft
@onready var cableHeadRight: Item =  $CableRight
@onready var batteryContainer: ItemContainer = $DropZone

var startPositionLeft
var startPositionRight
var currentBattery: Battery

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
	cableHeadLeft.make_grabable()
	cableHeadRight.make_grabable()
	
	currentBattery.grabbed_empty_battery.connect(remove_battery)
	currentBattery.no_charges_left.connect(_on_empty_battery)
	
func _on_empty_battery():
	disable_cables()
	currentBattery.make_grabable()
	currentBattery.no_charges_left.disconnect(_on_empty_battery)
	
func remove_battery():
	if currentBattery:
		disable_cables()
		currentBattery.grabbed_empty_battery.disconnect(remove_battery)
		batteryContainer.remove_contained_item()
		currentBattery = null

func disable_cables():
	cableHeadLeft.make_ungrabable()
	cableHeadRight.make_ungrabable()

func _on_drop_zone_item_dropped(newBattery):
	if not currentBattery:
		insert_battery(newBattery)
		
func _on_cable_left_cable_connect():
	currentBattery.use_charge()
	cableHeadLeft.make_ungrabable()

func _on_cable_right_cable_connect():
	currentBattery.use_charge()
	cableHeadRight.make_ungrabable()

func _on_cable_left_cable_disconnect():
	cableHeadLeft.global_position = startPositionLeft
	if currentBattery and currentBattery.charges != 0:
		cableHeadLeft.make_grabable()

func _on_cable_right_cable_disconnect():
	cableHeadRight.global_position = startPositionRight
	if currentBattery and currentBattery.charges != 0:
		cableHeadRight.make_grabable()
	
