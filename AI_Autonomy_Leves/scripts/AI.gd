class_name ArtificalIntelligence extends CharacterBody2D

@export var desiredDistance: float

@onready var controller = $Controller
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var currentSnippet: BehaviorSnippet
var batterySnippet: BehaviorSnippet

var grabableBatteries: Array[Battery]
var grabableEmptyBatteries: Array[Battery]
var emptyPylons: Array[Node2D]
var grabableRedCables: Array[CableHead]
var grabableGreenCables: Array[CableHead]
var grabableBlueCables: Array[CableHead]

var connectionPointRed = {}
var connectionPointGreen = {}
var connectionPointBlue = {}

@onready var recyclePoint = $"../BatteryDropZone"

func _ready():
	navigation_agent.target_desired_distance = desiredDistance
	# Green Pylon
	var greenPylon = $"../NavigationRegion2D/BatteryPylonGreen" as BatteryPylon
	
	var cableLeftGreen = greenPylon.cableHeadLeft as CableHead
	cableLeftGreen.grabable.connect(add_grabableCable)
	cableLeftGreen.ungrabable.connect(remove_grabableCable)
	
	var cableRightGreen = greenPylon.cableHeadRight as CableHead
	cableRightGreen.grabable.connect(add_grabableCable)
	cableRightGreen.ungrabable.connect(remove_grabableCable)
	
	add_pylon(greenPylon)
	
	# Red pylon
	var redPylon = $"../NavigationRegion2D/BatteryPylonRed" as BatteryPylon
	
	var cableLeftRed = redPylon.cableHeadLeft as CableHead
	cableLeftRed.grabable.connect(add_grabableCable)
	cableLeftRed.ungrabable.connect(remove_grabableCable)
	
	var cableRightRed = redPylon.cableHeadRight as CableHead
	cableRightRed.grabable.connect(add_grabableCable)
	cableRightRed.ungrabable.connect(remove_grabableCable)
	
	add_pylon(redPylon)
	
	# Blue pylon
	var bluePylon = $"../NavigationRegion2D/BatteryPylonBlue" as BatteryPylon
	
	var cableLeftBlue = bluePylon.cableHeadLeft as CableHead
	cableLeftBlue.grabable.connect(add_grabableCable)
	cableLeftBlue.ungrabable.connect(remove_grabableCable)
	
	var cableRightBlue = bluePylon.cableHeadRight as CableHead
	cableRightBlue.grabable.connect(add_grabableCable)
	cableRightBlue.ungrabable.connect(remove_grabableCable)
	
	add_pylon(bluePylon)
	
	batterySnippet = BatteryPlaceSnippet.new()
	batterySnippet.evaluate_utiliy(self)
	currentSnippet = batterySnippet

func reset():
	controller.change_direction(Vector2.ZERO)
	currentSnippet = null
	
func try_get_next_task():
	batterySnippet = BatteryPlaceSnippet.new()
	var utility = batterySnippet.evaluate_utiliy(self)
	
	if utility > 0:
		currentSnippet = batterySnippet

func _process(_delta):
	if currentSnippet == null:
		try_get_next_task()
		return
	
	currentSnippet.run_behavior(self)
	
func grab():
	controller.grab()
	
func drop():
	controller.let_go()

func move():
	var direction: Vector2 = Vector2(0,0)
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	controller.change_direction(direction)

########################### DATA COLLECTING ##################################

func add_battery(battery: Battery):
	grabableBatteries.append(battery)
	
	if not battery.no_charges_left.is_connected(add_emptyBattery):
		battery.no_charges_left.connect(add_emptyBattery)
	
	if not battery.grabbed_item.is_connected(remove_battery):
		battery.grabbed_item.connect(remove_battery)

func remove_battery(battery: Battery):
	for i in range(grabableBatteries.size() -1, -1, -1):
		if grabableBatteries[i] == battery:
			grabableBatteries.remove_at(i)
			
			if not battery.dropped_item.is_connected(add_battery):
				battery.dropped_item.connect(add_battery)

func add_emptyBattery(battery: Battery):
	grabableEmptyBatteries.append(battery)
	
	if not battery.grabbed_item.is_connected(remove_emptyBattery):
		battery.dropped_item.disconnect(add_battery)
		battery.grabbed_item.disconnect(remove_battery)
		battery.grabbed_item.connect(remove_emptyBattery)

func remove_emptyBattery(battery: Battery):
	for i in range(grabableEmptyBatteries.size() -1, -1, -1):
		if grabableEmptyBatteries[i] == battery:
			grabableEmptyBatteries.remove_at(i)
			
			if not battery.dropped_item.is_connected(add_emptyBattery):
				battery.dropped_item.connect(add_emptyBattery)

func add_pylon(batteryPylon: BatteryPylon):
	emptyPylons.append(batteryPylon)
	
func remove_pylon(batteryPylon: BatteryPylon):
	for i in range(emptyPylons.size() -1, -1, -1):
		if emptyPylons[i] == batteryPylon:
			emptyPylons.remove_at(i)

func add_grabableCable(cableHead: CableHead):
	match cableHead.cableColor:
		# Red
		0:
			grabableRedCables.append(cableHead)
		# Blue
		1:
			grabableBlueCables.append(cableHead)
		# Green
		2:
			grabableGreenCables.append(cableHead)
		# Default
		_:
			pass

func remove_grabableCable(cableHead: CableHead):
	var currentArray: Array[CableHead]
	
	match cableHead.cableColor:
		# Red
		0:
			currentArray = grabableRedCables
		# Blue
		1:
			currentArray = grabableBlueCables
		# Green
		2:
			currentArray = grabableGreenCables			
		# Default
		_:
			pass
			
	if not currentArray:
		return
	
	for i in range(currentArray.size() -1, -1, -1):
		if currentArray[i] == cableHead:
			currentArray.remove_at(i)
	
func addConnectionPoint(truck: Truck):
	if not truck.cable_connected.is_connected(removeConnectionPoint):
		truck.cable_connected.connect(removeConnectionPoint)
	
	var points: Array[DropZoneCable]
	
	for child in truck.get_children():
		if child is DropZoneCable:
			var connectionPoint = child as DropZoneCable
			
			if not connectionPoint.charged:
				points.append(child)
	
	for point in points:
		if point.charged == true:
			continue
			
		if truck.cableDictionary.has(GlobalEnums.CableColor.RED) and truck.cableDictionary[GlobalEnums.CableColor.RED] == false:
			if not connectionPointRed.has(point):
				connectionPointRed[point] = true
	
		if truck.cableDictionary.has(GlobalEnums.CableColor.BLUE) and truck.cableDictionary[GlobalEnums.CableColor.BLUE] == false:
			if not connectionPointBlue.has(point):
				connectionPointBlue[point] = true
	
		if truck.cableDictionary.has(GlobalEnums.CableColor.GREEN) and truck.cableDictionary[GlobalEnums.CableColor.GREEN] == false:
			if not connectionPointGreen.has(point):
				connectionPointGreen[point] = true
	
func removeConnectionPoint(truck: Truck):
	var points: Array[DropZoneCable]
	
	for child in truck.get_children():
		if child is DropZoneCable:
			points.append(child)
	
	for point in points:
		connectionPointRed.erase(point)
		connectionPointBlue.erase(point)
		connectionPointGreen.erase(point)
	
	addConnectionPoint(truck)
