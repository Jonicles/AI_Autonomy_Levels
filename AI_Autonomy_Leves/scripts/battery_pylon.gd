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
	currentBattery.grabbed_item.connect(remove_battery)
	
func remove_battery():
	if currentBattery:
		currentBattery.grabbed_item.disconnect(remove_battery)
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
	
	if currentBattery.charges == 0:
		disable_cables()

func _on_cable_right_cable_connect():
	currentBattery.use_charge()
	
	if currentBattery.charges == 0:
		disable_cables()

func _on_cable_left_cable_disconnect():
	if currentBattery and currentBattery.charges == 0:
		currentBattery.make_grabable()
		disable_cables()
	elif not currentBattery:
		disable_cables()
		
	cableHeadLeft.global_position = startPositionLeft

func _on_cable_right_cable_disconnect():
	if currentBattery and currentBattery.charges == 0:
		currentBattery.make_grabable()
		disable_cables()
	elif not currentBattery:
		disable_cables()
		
	cableHeadRight.global_position = startPositionRight
