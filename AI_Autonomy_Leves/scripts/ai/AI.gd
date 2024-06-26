class_name ArtificalIntelligence extends CharacterBody2D

@export var desiredDistance: float

@onready var controller: CharacterController = $Controller
@onready var iconSwitcher: IconSwitcher = $ActionIcons
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var recyclePoint: Node2D = $"../BatteryDropZone"
@onready var centerPoint: Node2D = $"../CenterPoint"
@onready var player: PlayerInput = $"../Player"

var currentSnippet: BehaviorSnippet
var utility: int = 0

var grabableBatteries: Array[Battery]
var grabableEmptyBatteries: Array[Battery]
var emptyPylons: Array[Node2D]
var grabableRedCables: Array[CableHead]
var grabableGreenCables: Array[CableHead]
var grabableBlueCables: Array[CableHead]

var connectionPointRed = {}
var connectionPointGreen = {}
var connectionPointBlue = {}

func _ready():
	navigation_agent.debug_enabled = false
	navigation_agent.target_desired_distance = desiredDistance
	# Green Pylon
	var greenPylon = $"../NavigationRegion2D/BatteryPylonGreen" as BatteryPylon
	
	greenPylon.battery_insert.connect(remove_pylon)
	greenPylon.battery_removal.connect(add_pylon)
	
	var cableLeftGreen = greenPylon.cableHeadLeft as CableHead
	cableLeftGreen.grabable.connect(add_grabableCable)
	cableLeftGreen.ungrabable.connect(remove_grabableCable)
	
	var cableRightGreen = greenPylon.cableHeadRight as CableHead
	cableRightGreen.grabable.connect(add_grabableCable)
	cableRightGreen.ungrabable.connect(remove_grabableCable)
	
	add_pylon(greenPylon)
	
	# Red pylon
	var redPylon = $"../NavigationRegion2D/BatteryPylonRed" as BatteryPylon
	
	redPylon.battery_insert.connect(remove_pylon)
	redPylon.battery_removal.connect(add_pylon)
	
	var cableLeftRed = redPylon.cableHeadLeft as CableHead
	cableLeftRed.grabable.connect(add_grabableCable)
	cableLeftRed.ungrabable.connect(remove_grabableCable)
	
	var cableRightRed = redPylon.cableHeadRight as CableHead
	cableRightRed.grabable.connect(add_grabableCable)
	cableRightRed.ungrabable.connect(remove_grabableCable)
	
	add_pylon(redPylon)
	
	# Blue pylon
	var bluePylon = $"../NavigationRegion2D/BatteryPylonBlue" as BatteryPylon
	
	bluePylon.battery_insert.connect(remove_pylon)
	bluePylon.battery_removal.connect(add_pylon)
	
	var cableLeftBlue = bluePylon.cableHeadLeft as CableHead
	cableLeftBlue.grabable.connect(add_grabableCable)
	cableLeftBlue.ungrabable.connect(remove_grabableCable)
	
	var cableRightBlue = bluePylon.cableHeadRight as CableHead
	cableRightBlue.grabable.connect(add_grabableCable)
	cableRightBlue.ungrabable.connect(remove_grabableCable)
	
	add_pylon(bluePylon)
	
	# Battery Spawner
	var batterySpawner = $"../BatterySpawner" as BatterySpawner
	batterySpawner.battery_spawned.connect(add_battery)
	
	# Truck Spawner
	var truckSpawner = $"../NavigationRegion2D/TruckSpawner" as TruckSpawner
	truckSpawner.truck_spawned.connect(addConnectionPoint)

func activate():
	controller.activate()

func deactivate():
	controller.deactivate()

func reset():
	utility = 0
	drop()
	controller.change_direction(Vector2.ZERO)
	
func try_get_next_task():
	if currentSnippet == null: 
		return
		
	utility = currentSnippet.evaluate_utility(self)
	if utility == 0:
		navigation_agent.target_position = centerPoint.global_position
		move()

func _process(_delta):
	if currentSnippet == null:
		return

	if utility == 0:
		try_get_next_task()
		return
	currentSnippet.run_behavior(self)
	
func grab():
	controller.grab()
	
func drop():
	controller.let_go()
	
func throw():
	controller.throw()

func move():
	if navigation_agent.is_navigation_finished():
		controller.change_direction(Vector2.ZERO)
		return
		
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
	
	var points: Array[DropZoneCable] = []
	
	for point in truck.connectionPoints as Array[DropZoneCable]:
		if not point.charged:
			points.append(point)
	
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
	var points: Array[DropZoneCable] = []
	
	for point in truck.connectionPoints as Array[DropZoneCable]:
		points.append(point)
	
	for point in points:
		connectionPointRed.erase(point)
		connectionPointBlue.erase(point)
		connectionPointGreen.erase(point)
	
	addConnectionPoint(truck)
