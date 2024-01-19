extends CharacterBody2D

@onready var controller = $Controller
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _process(delta):
	navigation_agent.target_position = get_global_mouse_position()
	
	var direction: Vector2 = Vector2(0,0)
	
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	controller.change_direction(direction)
