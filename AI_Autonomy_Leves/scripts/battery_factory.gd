extends Node

var batteryNode = load("res://scenes/battery.tscn")
var currentBattery: Battery

func _ready():
	spawn_battery()

func spawn_battery():
	currentBattery = batteryNode.instantiate()
	add_child(currentBattery)
	currentBattery.grabbed_battery.connect(_on_grabbed_battery)

func _on_grabbed_battery():
	spawn_battery()
