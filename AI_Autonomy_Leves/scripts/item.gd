class_name Item extends Area2D

const THROWING_DISTANCE: int = 100

var currentHolder: CharacterController
var previousHolder: CharacterController

var isGrabable: bool = true

var currentPosition: Vector2
var destination: Vector2
var inAir: bool = false
var elapsedTime
var throwingTime = 0.3

signal grabbed_item
signal dropped_item

func drop():
	previousHolder = currentHolder
	currentHolder = null

func grab(character: CharacterController):
	currentHolder = character
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
		drop()

func immediate_drop():
	if not currentHolder:
		return
		
	currentHolder.remove_item()

func make_grabable():
	isGrabable = true

func make_ungrabable():
	isGrabable = false
