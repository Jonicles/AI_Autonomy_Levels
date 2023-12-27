class_name CharacterController
extends Node

@export var body: CharacterBody2D
@export var speed: int
@onready var grabRadius: Area2D = %GrabRadius

var currentDirection = Vector2.ZERO
var heldObject: PhysicsBody2D

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

func grab():
	if heldObject:
		return
	
	var objects: Array[Node2D] = grabRadius.get_overlapping_bodies()
	
	if not objects:
		return
	
	for i in objects:
		#FIND CLOSEST DISTANCE TO OBJECT HERE
		pass
	
	heldObject = objects[0]
	print("Grabbing " + heldObject.name)

func let_go():
	if not heldObject:
		return
		
	print("Letting go of " + heldObject.name)
	heldObject = null

func throw():
	if not heldObject:
		return
	
	print("Throwing " + heldObject.name)
	heldObject = null
