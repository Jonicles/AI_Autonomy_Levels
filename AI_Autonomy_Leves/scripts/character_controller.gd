class_name CharacterController
extends Node

@export var body: CharacterBody2D
@export var speed: int
@export var itemPixelsOffset: float = 32

@onready var grabRadius: Area2D = %GrabRadius
@onready var scoreKeeper: ScoreKeeper = %ScoreKeeper

var currentDirection = Vector2.ZERO
var itemDirection = Vector2.DOWN
var itemNode: Area2D
var heldItem: Item

var isActive = false

func activate():
	isActive = true

func deactivate():
	isActive = false

func change_direction(newDirection: Vector2):
	currentDirection = newDirection
	itemDirection = currentDirection

func _physics_process(delta):
	if not isActive:
		return
		
	body.move_and_collide(currentDirection * speed * delta )
	
	if not heldItem:
		return
	
	itemNode.global_position = body.global_position + itemDirection * Vector2(itemPixelsOffset, itemPixelsOffset)

func grab():
	if not isActive:
		return
	
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
	heldItem.grab(self)
	
func let_go():
	if not isActive:
		return
	
	if not heldItem:
		return
	
	heldItem.drop()
	itemNode = null
	heldItem = null

func remove_item():
	if not isActive:
		return
	
	if not heldItem:
		return
	
	itemNode = null	
	heldItem = null
	
func throw():
	if not isActive:
		return
	
	if not heldItem:
		return
	
	heldItem.throw(itemDirection)
	itemNode = null
	heldItem = null

func add_score(pointsToAdd: int):
	scoreKeeper.add_score(pointsToAdd)
