class_name SpawnPoint extends Node2D

var occupied: bool = false
var currentTruck: Truck

func occupy(truck: Truck):
	currentTruck = truck
	truck.charge_complete.connect(_on_charge_complete)
	occupied = true
	
func leave():
	occupied = false

func _on_charge_complete():
	currentTruck.charge_complete.disconnect(_on_charge_complete)
	currentTruck.queue_free()
	currentTruck = null
	leave()
