extends Item

@export var cableColor := GlobalEnums.CableColor.RED
@onready var cableHeadNode: Area2D = $"."

var startPosition: Vector2
var itemType := GlobalEnums.ItemType.CABLE

func _ready():
	startPosition = global_position

#Overriden Drop method
func drop():
	var areas: Array[Area2D] = get_overlapping_areas()
	
	if not areas:
		return
	
	var zone = areas[0] as DropZoneCable
	zone.try_drop_off(cableColor, cableHeadNode)

func return_to_start():
	global_position = startPosition

func make_ungrabable():
	isGrabable = false

func make_grabable():
	return_to_start()
	isGrabable = true
