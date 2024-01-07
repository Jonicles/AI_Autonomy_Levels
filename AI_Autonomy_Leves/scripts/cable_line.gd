class_name CableLine extends Line2D

@export var cableHead: Node2D
@export var cableOffest = Vector2(24,0)
@export var color = Color.BLUE
@onready var staticBody: StaticBody2D = %StaticBody2D
@onready var electricityTimer: Timer = $ElectricityTimer

var maxCableDistance = 128

func _ready():
	reset_cable()

func reset_cable():
	clear_points()
	 
	if staticBody.get_child_count() > 0: 
		for child in staticBody.get_children():
			var childNode: Node = child
			staticBody.remove_child(childNode)
			childNode.queue_free()
	
	var startPostion = position + cableOffest
	add_point(startPostion)
	add_point(startPostion)
	default_color = color

func _process(_delta):
	try_add_point()
	points[points.size() - 1] = cableHead.position + cableOffest

func try_add_point():
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 
	
	if currentPoint.distance_to(previousPoint) > maxCableDistance:
		add_cable_point(currentPoint, previousPoint)

func add_cable_point(currentPoint, previousPoint):
	var collisionShape = CollisionShape2D.new()
	var segment = SegmentShape2D.new()
	segment.a = previousPoint
	segment.b = currentPoint
	collisionShape.shape = segment
	collisionShape.disabled = true
	
	staticBody.add_child(collisionShape)
	add_point(cableHead.position + cableOffest)

func start_electrification():
	electricityTimer.start()

func activate_collision():
	# Add a point to make sure that collision is all the way
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 
	add_cable_point(currentPoint, previousPoint)
	
	for child in staticBody.get_children():
		var collisionShape = child as CollisionShape2D
		collisionShape.disabled = false

func _on_electricity_timer_timeout():
	activate_collision()
	blink()

func blink():
	default_color = Color.YELLOW
