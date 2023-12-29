class_name CharacterController
extends Node

@export var body: CharacterBody2D
@export var speed: int
@onready var grabRadius: Area2D = %GrabRadius

var currentDirection = Vector2.ZERO
var heldItem: Area2D
var itemScript: Item

func move(direction: Vector2):
	if direction == Vector2.UP:
		currentDirection = Vector2.UP
	elif direction == Vector2.DOWN:
		currentDirection = Vector2.DOWN
	elif direction == Vector2.LEFT:
		currentDirection = Vector2.LEFT
	elif direction == Vector2.RIGHT:
		currentDirection = Vector2.RIGHT
	else :
		currentDirection = Vector2.ZERO

func _physics_process(delta):
	body.move_and_collide(currentDirection * delta * speed)
	
	if not heldItem:
		return
	
	heldItem.position = body.position

func grab():
	if heldItem:
		return
	
	var objects: Array[Area2D] = grabRadius.get_overlapping_areas()
	
	if not objects:
		return
	
	var closestDistance = INF
	var object
	
	for i in objects:
		var distance = grabRadius.position.distance_to(i.position)
		
		if distance < closestDistance:
			closestDistance = distance
			object = i 
	
	heldItem = object
	itemScript = heldItem as Item

func let_go():
	if not heldItem:
		return
	
	itemScript.drop()
	heldItem = null

func throw():
	if not heldItem:
		return
	
	heldItem = null
