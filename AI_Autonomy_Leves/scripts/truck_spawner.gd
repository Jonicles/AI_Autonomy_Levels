class_name TruckSpawner extends Node

@onready var pointsParent = $SpawnPoints
@onready var timer: Timer = $Timer

signal truck_spawned

var truckDownLeft = preload("res://scenes/truck_down_left.tscn")
var truckDownRight = preload("res://scenes/truck_down_right.tscn")
var truckUpLeft = preload("res://scenes/truck_up_left.tscn")
var truckUpRight = preload("res://scenes/truck_up_right.tscn")
var truckLeftRight = preload("res://scenes/truck_left_right.tscn")
var truckUpDown = preload("res://scenes/truck_up_down.tscn")

var truckTriUp = preload("res://scenes/truck_tri_up.tscn")
var truckTriDown = preload("res://scenes/truck_tri_down.tscn")
var truckTriLeft = preload("res://scenes/truck_tri_left.tscn")
var truckTriRight = preload("res://scenes/truck_tri_right.tscn")

#var allTrucks: Array = []
var dualTrucks: Array = []
var triTrucks: Array = []

var spawnPoints: Array[SpawnPoint]
var numberOfTriTrucks: int = 0
const maxNumberOfTriTrucks = 2

func _ready():
	#allTrucks.append(truckDownLeft)
	#allTrucks.append(truckDownRight)
	#allTrucks.append(truckUpLeft)
	#allTrucks.append(truckUpRight)
	#allTrucks.append(truckLeftRight)
	#allTrucks.append(truckUpDown)
	#allTrucks.append(truckTriUp)
	#allTrucks.append(truckTriDown)
	#allTrucks.append(truckTriLeft)
	#allTrucks.append(truckTriRight)
	
	dualTrucks.append(truckDownLeft)
	dualTrucks.append(truckDownRight)
	dualTrucks.append(truckUpLeft)
	dualTrucks.append(truckUpRight)
	dualTrucks.append(truckLeftRight)
	dualTrucks.append(truckUpDown)
	
	triTrucks.append(truckTriUp)
	triTrucks.append(truckTriDown)
	triTrucks.append(truckTriLeft)
	triTrucks.append(truckTriRight)
	
	var spawnNodes = pointsParent.get_children() 
	var navRegion: NavRegion = get_node("/root/Main/NavigationRegion2D")
	
	for node in spawnNodes:
		var spawnPoint = node as SpawnPoint
		spawnPoints.append(spawnPoint)
		spawnPoint.truck_despawned.connect(navRegion._on_truck_despawned)

func spawn():
	var availableSpawnPoints: Array[SpawnPoint] = []
	
	for i in spawnPoints:
		if not i.occupied:
			availableSpawnPoints.append(i)
	
	if not availableSpawnPoints:
		return
	
	var spawnPoint = availableSpawnPoints.pick_random() as SpawnPoint
	
	var truck 
	if numberOfTriTrucks >= maxNumberOfTriTrucks:
		truck = dualTrucks.pick_random()
	else:
		truck = triTrucks.pick_random()
		
	var instance: Truck = truck.instantiate()
	spawnPoint.add_child(instance)
	spawnPoint.occupy(instance)
	instance.global_position = spawnPoint.global_position
	
	if not instance.charge_complete.is_connected(_on_visit_complete):
		instance.charge_complete.connect(_on_visit_complete)
	if instance.colorRects.size() == 3:
		numberOfTriTrucks += 1
	
	truck_spawned.emit(instance as Truck)

func _on_visit_complete(truck: Truck):
	if truck.colorRects.size() == 3:
		numberOfTriTrucks -= 1

func _on_timer_timeout():
	spawn()
