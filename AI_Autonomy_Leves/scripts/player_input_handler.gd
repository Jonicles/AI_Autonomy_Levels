class_name PlayerInput extends CharacterBody2D

@onready var controller = $Controller
@onready var navigationAgent = $NavigationAgent2D

func _process(_delta):
	var inputDirection: Vector2 = Vector2(0,0)
	
	if Input.is_action_pressed("Player_Up"):
		inputDirection += Vector2.UP
	
	if Input.is_action_pressed("Player_Down"):
		inputDirection += Vector2.DOWN
	
	if Input.is_action_pressed("Player_Right"):
		inputDirection += Vector2.RIGHT
		
	if Input.is_action_pressed("Player_Left"):
		inputDirection += Vector2.LEFT
		
	controller.change_direction(inputDirection.normalized())

func _input(event):
	# Handle grab
	if event.is_action_pressed("Player_Grab"):
		controller.grab()
	elif event.is_action_released("Player_Grab"):
		controller.let_go()
		
	# Handle throw
	if event.is_action_pressed("Player_Throw"):
		controller.throw()
	
	# Handle movement
	#var isActionReleased: bool = (
		#event.is_action_released("Player_Up") or event.is_action_released("Player_Down") 
		#or event.is_action_released("Player_Left") or event.is_action_released("Player_Right") 
	#)
	#
	#var hasInput: bool = (
		#Input.is_action_pressed("Player_Up") or Input.is_action_pressed("Player_Down") 
		#or Input.is_action_pressed("Player_Left") or Input.is_action_pressed("Player_Right")
	#)
	#
	#if isActionReleased and not hasInput:
		#controller.change_direction(Vector2.ZERO)
	#elif event.is_action_pressed("Player_Up"):
		#controller.change_direction(Vector2.UP)
	#elif event.is_action_pressed("Player_Down"):
		#controller.change_direction(Vector2.DOWN)
	#elif event.is_action_pressed("Player_Right"):
		#controller.change_direction(Vector2.RIGHT)
	#elif event.is_action_pressed("Player_Left"):
		#controller.change_direction(Vector2.LEFT)
