class_name IconSwitcher extends Node2D

@onready var assistIcon: Control = $Assist
@onready var soloIcon: Control = $Solo

@onready var batteryIcon: Control = $Battery
@onready var recycleIcon: Control = $Recycle
@onready var cableIcon: Control = $Cable

var iconDictionary: Dictionary = {}

var currentActionIcon: Control
var currentModeIcon: Control

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
