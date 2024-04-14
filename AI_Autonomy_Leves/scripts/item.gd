class_name Item extends Area2D

const THROWING_DISTANCE: int = 100

var isGrabable: bool = true

var currentPosition: Vector2
var destination: Vector2
var inAir: bool = false
var elapsedTime
var throwingTime = 0.3

signal grabbed_item
signal dropped_item

func drop():
	pass

func grab():
	grabbed_item.emit()

func throw(direction: Vector2):
	currentPosition = global_position
	destination = global_position + direction * THROWING_DISTANCE
	inAir = true
	elapsedTime = 0

func _physics_process(delta):
	if not inAir:
		return
	elapsedTime += delta
	
	if elapsedTime < throwingTime:
		global_position = currentPosition + (destination - currentPosition) * (elapsedTime / throwingTime)
	else:
		inAir = false
		make_grabable()
	
func make_grabable():
	isGrabable = true

func make_ungrabable():
	isGrabable = false
