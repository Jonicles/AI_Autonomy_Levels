class_name Battery extends Item

@export var charges = 3
@onready var battery: Item = $"."
@onready var label: Label = $Label
@onready var explosionTimer: Timer = $Timer

signal grabbed_empty_battery
signal no_charges_left

var itemType := GlobalEnums.ItemType.BATTERY

func drop():
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		explosionTimer.start()
		return
	
	var zone = areas[0] as DropZone
	if not zone.try_drop_off(itemType, battery):
		explosionTimer.start()

func grab():
	explosionTimer.stop()
	grabbed_item.emit()
	
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
	no_charges_left.emit()

func explode():
	queue_free()

func _on_timer_timeout():
	explode()
	make_ungrabable()
	explosionTimer.stop()
