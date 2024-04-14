class_name CharacterController
extends Node

@export var body: CharacterBody2D
@export var speed: int
@export var itemPixelsOffset: float = 32

@onready var grabRadius: Area2D = %GrabRadius

var currentDirection = Vector2.ZERO
var itemDirection = Vector2.DOWN
var itemNode: Area2D
var heldItem: Item

func change_direction(newDirection: Vector2):
	currentDirection = newDirection
	itemDirection = currentDirection

func _physics_process(delta):
	body.move_and_collide(currentDirection * speed * delta )
	
	if not heldItem:
		return
	
	itemNode.global_position = body.global_position + itemDirection * Vector2(itemPixelsOffset, itemPixelsOffset)

func grab():
	if heldItem:
		return
	
	var objects: Array[Area2D] = grabRadius.get_overlapping_areas()
	
	if not objects:
		return
	
	var closestDistance = INF
	var object
	
	for i in objects:
		var item = i as Item
		
		if not item.isGrabable:
			continue
		
		var distance = grabRadius.position.distance_to(i.position)
		if distance < closestDistance:
			closestDistance = distance
			object = i 
	
	if not object:
		return
		
	itemNode = object
	heldItem = itemNode as Item
	heldItem.grab()
	
	if not heldItem.drop_immediately.is_connected(let_go_without_drop):
		heldItem.drop_immediately.connect(let_go_without_drop)

func let_go():
	if not heldItem:
		return
	
	if heldItem.drop_immediately.is_connected(let_go_without_drop):
		heldItem.drop_immediately.disconnect(let_go_without_drop)
	
	heldItem.drop()
	itemNode = null
	heldItem = null

func let_go_without_drop():
	if not heldItem:
		return
	
	if heldItem.drop_immediately.is_connected(let_go_without_drop):
		heldItem.drop_immediately.disconnect(let_go_without_drop)
	
	itemNode = null	
	heldItem = null
func throw():
	if not heldItem:
		return
	
	heldItem.throw(itemDirection)
	itemNode = null
	heldItem = null
