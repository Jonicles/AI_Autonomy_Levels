extends Button

@export var scenePath: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(load_scene)

func load_scene():
	pressed.disconnect(load_scene)
	get_tree().change_scene_to_file(scenePath)
