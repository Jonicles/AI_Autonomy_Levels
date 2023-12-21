class_name CharacterController
extends Node

@export var body: CharacterBody2D

func Move(direction: Vector2):
	if direction == Vector2.UP:
		body.transform += Vector2.UP
	elif direction == Vector2.DOWN:
		print("Move Down!");
	elif direction == Vector2.LEFT:
		print("Move Left!");
	elif direction == Vector2.RIGHT:
		print("Move Right!");


