class_name IconSwitcher extends Node2D

@onready var assistIcon: Node2D = $Assist
@onready var soloIcon: Node2D = $Solo

@onready var batteryIcon: Node2D = $Battery
@onready var recycleIcon: Node2D = $Recycle
@onready var cableIcon: Node2D = $Cable

var iconDictionary: Dictionary = {}

var currentActionIcon: Node2D
var currentModeIcon: Node2D

func _ready():
	iconDictionary["Assist"] = assistIcon
	iconDictionary["Solo"] = soloIcon
	iconDictionary["Battery"] = batteryIcon
	iconDictionary["Recycle"] = recycleIcon
	iconDictionary["Cable"] = cableIcon
	
	set_mode_icon("Solo")
	
func set_action_icon(iconKey: String):
	if not iconDictionary.has(iconKey):
		print("Icon key not found, exiting")
		return
	
	if currentActionIcon:
		currentActionIcon.hide()
		
	currentActionIcon = iconDictionary[iconKey]
	currentActionIcon.show()
	
func set_mode_icon(iconKey: String):
	if not iconDictionary.has(iconKey):
		print("Icon key not found, exiting")
		return
	
	if currentModeIcon:
		currentModeIcon.hide()
		
	currentModeIcon = iconDictionary[iconKey]
	currentModeIcon.show()
	
func fade_icon():
	pass
