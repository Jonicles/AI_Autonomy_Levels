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

var trucks: Array = []
var spawnPoints: Array[SpawnPoint]

func _ready():
	trucks.append(truckDownLeft)
	trucks.append(truckDownRight)
	trucks.append(truckUpLeft)
	trucks.append(truckUpRight)
	trucks.append(truckLeftRight)
	trucks.append(truckUpDown)
	
	trucks.append(truckTriUp)
	trucks.append(truckTriDown)
	trucks.append(truckTriLeft)
	trucks.append(truckTriRight)
	
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
	var truck = trucks.pick_random()
	var instance = truck.instantiate()
	spawnPoint.add_child(instance)
	spawnPoint.occupy(instance)
	instance.global_position = spawnPoint.global_position
	truck_spawned.emit(instance as Truck)

func _on_timer_timeout():
	spawn()
