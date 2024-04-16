class_name SpawnPoint extends Node2D

signal truck_despawned

var occupied: bool = false
var currentTruck: Truck

func occupy(truck: Truck):
	currentTruck = truck
	truck.charge_complete.connect(_on_charge_complete)
	occupied = true
	
func leave():
	currentTruck.queue_free()	
	currentTruck = null
	occupied = false
	truck_despawned.emit()
	
func _on_charge_complete(_node):
	leave()
