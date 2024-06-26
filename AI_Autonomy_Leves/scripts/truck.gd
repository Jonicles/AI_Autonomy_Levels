extends StaticBody2D

class_name Truck

@export var connectionAmount: int = 2
@onready var timer: Timer = $Timer
@onready var colorRectParent = $ColorRects
@onready var dropZoneParent = $DropZones

signal charge_complete
signal cable_connected

var cableDictionary: Dictionary = {}
var connectedCables: Array[CableHead] = []
var colorRects: Array[Node] = []
var connectionPoints: Array[Node]

const COLOR_RED: Color = Color.RED
const COLOR_BLUE: Color = Color.BLUE
const COLOR_GREEN: Color = Color.GREEN
const COLOR_PURPLE: Color = Color.PURPLE


func _ready():
	colorRects = colorRectParent.get_children()
	connectionPoints = dropZoneParent.get_children()
	
	randomize_initial_cables()

func try_connect_cable(cableColor):
	if not cableDictionary.has(cableColor):
		return false
	
	if cableDictionary[cableColor] == true:
		return false
	
	return true
	
func connect_cable(cableColor, cableHead: CableHead):
	cableHead.connect_head()
	
	cableDictionary[cableColor] = true
	connectedCables.append(cableHead)
	cable_connected.emit(self)
	update_connectionpoint_priority()
	check_if_fully_connected()

func update_connectionpoint_priority():
	for point in connectionPoints as Array[DropZoneCable]:
		if not point.charged:
			point.update_priority()
	
func check_if_fully_connected():
	for item in cableDictionary:
		if cableDictionary[item] == false:
			return
	timer.start()

func complete_visit():
	disconnect_cables()
	charge_complete.emit(self)

func disconnect_cables():
	for i in connectedCables:
		i.disconnect_head()
	
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
	update_display()
	
func update_display():
	var iterations: int = 0
	var keys: Array = cableDictionary.keys()
	
	while iterations < connectionAmount:
		var currentRect = colorRects[iterations] as ColorRect
		currentRect.color = get_color(keys[iterations])
		iterations += 1

func get_color(color):
	var tempColor
	
	# This reason for this implementation is because global enums is not
	# Really a thing in godot, thats why we use integer values instead
	
	match color:
		0:
			tempColor = COLOR_RED
		1:
			tempColor = COLOR_BLUE
		2:
			tempColor = COLOR_GREEN
		3:
			tempColor = COLOR_PURPLE
		_:
			tempColor = Color.BLACK

	return tempColor

func _on_timer_timeout():
	complete_visit()
