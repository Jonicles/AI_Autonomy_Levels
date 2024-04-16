extends Node

@export var countDownTime: int = 3
@export var timeLimit: int = 150

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

var currentTime: int = 0

signal time_limit_reached
signal count_down_finished

func _ready():
	currentTime = countDownTime
	label.text = str(currentTime)
	timer.timeout.connect(start_count_down)
	
	count_down_finished.connect(_on_count_down_finished)
	time_limit_reached.connect(_on_time_limit_reached)
	start_timer()

func start_timer():
	timer.start()

func start_count_down():
	currentTime -= 1
	update_display()
	
	if currentTime == 0:
		count_down_finished.emit()
		
func count_down():
	currentTime -= 1
	update_display()
	
	if currentTime == 0:
		time_limit_reached.emit()

func update_display():
	label.text = str(currentTime)

func _on_count_down_finished():
	currentTime = timeLimit
	update_display()
	timer.timeout.disconnect(start_count_down)
	timer.timeout.connect(count_down)
	
func _on_time_limit_reached():
	timer.stop()
	#get_tree().change_scene_to_file()
