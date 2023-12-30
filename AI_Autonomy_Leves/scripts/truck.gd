extends StaticBody2D

class_name Truck

@export var connectionAmount: int = 2
var cableDictionary: Dictionary = {}

func _ready():
	randomize_initial_cables()

func try_connect_cable(cableColor):
	if not cableDictionary.has(cableColor):
		return false
	
	if cableDictionary[cableColor] == false:
		connect_cable(cableColor)
	
func connect_cable(cableColor):
	cableDictionary[cableColor] = true
	print("Connection made!")
	if check_if_fully_connected():
		complete_visit()

func check_if_fully_connected():
	for item in cableDictionary:
		if cableDictionary[item] == false:
			return false
	return true

func complete_visit():
	disconnect_cables()
	queue_free()

func disconnect_cables():
	pass

func randomize_initial_cables():
	var availableColors: Array = GlobalEnums.CableColor.values()
	var connectionsMade: int = 0
		
	while connectionsMade != connectionAmount:
		var randomColor = availableColors.pick_random()
		
		if cableDictionary.has(randomColor):
			continue
		
		cableDictionary[randomColor] = false
		connectionsMade += 1
