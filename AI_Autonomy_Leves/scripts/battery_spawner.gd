extends Node

@onready var respawnTimer: Timer = $Timer

signal battery_spawned

var batteryNode = load("res://scenes/battery.tscn")
var currentBattery: Battery

func _ready():
	spawn_battery()

func spawn_battery():
	currentBattery = batteryNode.instantiate()
	add_child(currentBattery)
	currentBattery.grabbed_item.connect(_on_grabbed_battery)
	battery_spawned.emit(currentBattery as Battery)

func _on_grabbed_battery(_battery):
	currentBattery.grabbed_item.disconnect(_on_grabbed_battery)
	respawnTimer.start()

func _on_timer_timeout():
	spawn_battery()
	respawnTimer.stop()
