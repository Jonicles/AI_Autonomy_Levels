extends CharacterBody2D

@export var controller: CharacterController

func _input(event):
	if event.is_action_pressed("Player_Up"):
		controller.Move(Vector2.UP)
	elif event.is_action_pressed("Player_Down"):
		controller.Move(Vector2.DOWN)
	elif event.is_action_pressed("Player_Right"):
		controller.Move(Vector2.RIGHT)
	elif event.is_action_pressed("Player_Left"):
		controller.Move(Vector2.LEFT)
