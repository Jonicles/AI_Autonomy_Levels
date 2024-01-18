extends Node

var points: int = 0
var label: Label
	
func add_points(newPoints: int):
	points += newPoints
	update_UI()
	
func update_UI():
	var pointString = points as String
	label.text = pointString

func _on_battery_recycle():
	add_points(5)
	
func _on_truck2_charged():
	add_points(10)

func _on_truck3_charged():
	add_points(15)

func connect_truck2(truck: Truck):
	truck.charge_complete.connect(_on_truck2_charged)		

func connect_truck3(truck: Truck):
	truck.charge_complete.connect(_on_truck3_charged)	

func connect_battery_dropzone(batteryDropZone: DropZone):
	batteryDropZone.item_dropped.connect(_on_battery_recycle)
