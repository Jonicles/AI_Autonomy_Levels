extends StaticBody2D

class_name Truck

@export var connectionAmount: int = 2
@onready var timer: Timer = $Timer

var cableDictionary: Dictionary = {}
var connectedCables: Array[Item] = []

func _ready():
	randomize_initial_cables()

func try_connect_cable(cableColor, cableHeadNode):
	if not cableDictionary.has(cableColor):
		return false
	
	if cableDictionary[cableColor] == true:
		return false
	
	connect_cable(cableColor, cableHeadNode)
	return true
	
func connect_cable(cableColor, cableHeadNode: Area2D):
	var cableHead = cableHeadNode as Item
	cableHead.make_ungrabable()
	
	cableDictionary[cableColor] = true
	connectedCables.append(cableHead)
	check_if_fully_connected()

func check_if_fully_connected():
	for item in cableDictionary:
		if cableDictionary[item] == false:
			return
	timer.start()

func complete_visit():
	disconnect_cables()
	queue_free()

func disconnect_cables():
	for i in connectedCables:
		i.make_grabable()
	
	connectedCables.clear()

func randomize_initial_cables():
	var availableColors: Array = GlobalEnums.CableColor.values()
	var connectionsMade: int = 0
		
	while connectionsMade != connectionAmount:
		var randomColor = availableColors.pick_random()
		
		if cableDictionary.has(randomColor):
			continue
		
		cableDictionary[randomColor] = false
		connectionsMade += 1

func _on_timer_timeout():
	complete_visit()
