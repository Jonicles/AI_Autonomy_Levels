class_name Battery extends Item

@export var charges = 3
@onready var battery: Item = $"."
@onready var label: Label = $Label

signal grabbed_empty_battery
signal grabbed_battery

var itemType := GlobalEnums.ItemType.BATTERY

func drop():
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		return
	
	var zone = areas[0] as DropZone
	zone.try_drop_off(itemType, battery)

func grab():
	grabbed_battery.emit()
	
	if charges == 0:
		grabbed_empty_battery.emit()

func use_charge():
	if charges == 0:
		return
		
	charges -= 1
	
	update_display()
	
	if charges == 0:
		empty_battery()

func update_display():
	label.text = str(charges)

func empty_battery():
	pass
