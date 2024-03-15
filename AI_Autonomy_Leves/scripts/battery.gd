class_name Battery extends Item

@export var charges = 3
@onready var battery: Item = $"."
@onready var sprite: Sprite2D = $Sprite2D
#@onready var explosionTimer: Timer = $Timer

var battery2: Texture = preload("res://sprites/Battery_2.png")
var battery1: Texture = preload("res://sprites/Battery_1.png")
var battery0: Texture = preload("res://sprites/Battery_0.png")


signal grabbed_empty_battery
signal no_charges_left

var itemType := GlobalEnums.ItemType.BATTERY

func drop():
	make_grabable()
	var areas: Array[Area2D] = get_overlapping_areas()

	if not areas:
		#explosionTimer.start()
		dropped_item.emit(self)
		return

	var zone = areas[0] as DropZone
	if not zone.try_drop_off(itemType, battery):
		dropped_item.emit(self)
		#explosionTimer.start()

func grab():
	make_ungrabable()
	#explosionTimer.stop()
	grabbed_item.emit(self)
	
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
	match charges:
		2:
			sprite.texture = battery2
		1:
			sprite.texture = battery1
		0:
			sprite.texture = battery0

func empty_battery():
	no_charges_left.emit(self)

#func explode():
	#queue_free()
#
#func _on_timer_timeout():
	#explode()
	#make_ungrabable()
	##explosionTimer.stop()
