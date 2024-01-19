extends CharacterBody2D

@onready var controller = $Controller

func _process(delta):
	var inputDirection: Vector2 = Vector2(0,0)
	
	if Input.is_action_pressed("Player2_Up"):
		inputDirection += Vector2.UP
	
	if Input.is_action_pressed("Player2_Down"):
		inputDirection += Vector2.DOWN
	
	if Input.is_action_pressed("Player2_Right"):
		inputDirection += Vector2.RIGHT
		
	if Input.is_action_pressed("Player2_Left"):
		inputDirection += Vector2.LEFT
		
	controller.change_direction(inputDirection.normalized())

func _input(event):
	# Handle grab
	if event.is_action_pressed("Player2_Grab"):
		controller.grab()
	elif event.is_action_released("Player2_Grab"):
		controller.let_go()
		
	# Handle throw
	if event.is_action_pressed("Player2_Throw"):
		controller.throw()
