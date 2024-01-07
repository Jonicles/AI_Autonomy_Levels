extends CharacterBody2D

@onready var controller = $Controller

func _input(event):
	# Handle grab
	if event.is_action_pressed("Player2_Grab"):
		controller.grab()
	elif event.is_action_released("Player2_Grab"):
		controller.let_go()
		
	# Handle throw
	if event.is_action_pressed("Player2_Throw"):
		controller.throw()
	
	# Handle movement
	var isActionReleased: bool = (
			event.is_action_released("Player2_Up") or event.is_action_released("Player2_Down") 
			or event.is_action_released("Player2_Left") or event.is_action_released("Player2_Right") 
	)
	
	var hasInput: bool = (
		Input.is_action_pressed("Player2_Up") or Input.is_action_pressed("Player2_Down") 
		or Input.is_action_pressed("Player2_Left") or Input.is_action_pressed("Player2_Right")
	)
	
	if isActionReleased and not hasInput:
		controller.change_direction(Vector2.ZERO)
	elif event.is_action_pressed("Player2_Up"):
		controller.change_direction(Vector2.UP)
	elif event.is_action_pressed("Player2_Down"):
		controller.change_direction(Vector2.DOWN)
	elif event.is_action_pressed("Player2_Right"):
		controller.change_direction(Vector2.RIGHT)
	elif event.is_action_pressed("Player2_Left"):
		controller.change_direction(Vector2.LEFT)
		
