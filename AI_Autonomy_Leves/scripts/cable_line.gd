class_name CableLine extends Line2D

@export var cableHead: Node2D
@export var color = Color.BLUE
@onready var staticBody: StaticBody2D = %StaticBody2D
@onready var electricityTimer: Timer = $ElectricityTimer
@onready var deelectrificationTimer: Timer = $DeelectrificationTimer

signal cable_electrified
signal cable_reset

var maxCableDistance = 128
var lineThickness = 10

func _ready():
	var navRegion = get_tree().root.get_child(0).get_node("NavigationRegion2D") as NavRegion
	cable_electrified.connect(navRegion.rebake_nav_polygon)
	cable_reset.connect(navRegion.rebake_nav_polygon)
	
	reset_cable()
	
func reset_cable():
	clear_points()
	deactivate_collision()
	
	add_point(to_local(global_position))
	add_point(to_local(global_position))
	default_color = color
	cable_reset.emit()

func _process(_delta):
	try_add_point()
	points[points.size() - 1] = to_local(cableHead.global_position)

func try_add_point():
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 

	if currentPoint.distance_to(previousPoint) > maxCableDistance:
		add_cable_point(currentPoint, previousPoint)

func add_cable_point(currentPoint: Vector2, previousPoint: Vector2):
	var collisionPolygon: CollisionPolygon2D = CollisionPolygon2D.new()
	var vectorArray: Array[Vector2]
	
	var xDifference = abs(previousPoint.x - currentPoint.x)
	var yDifference = abs(previousPoint.y - currentPoint.y)
	
	var xPercentage = xDifference / maxCableDistance
	var yPercentage = yDifference / maxCableDistance
	
	# Safeguard to make sure ai cannot cross thin cable lines
	if abs(xDifference - yDifference) < 0.5 and ((currentPoint.x < previousPoint.x && currentPoint.y < previousPoint.y) or (currentPoint.x > previousPoint.x && currentPoint.y > previousPoint.y)):
		yPercentage = -yPercentage	 
	
	var offset: Vector2 = Vector2(lineThickness * yPercentage, lineThickness * xPercentage)
	
	vectorArray.append(currentPoint + offset)	
	vectorArray.append(currentPoint - offset)
	vectorArray.append(previousPoint - offset)
	vectorArray.append(previousPoint + offset)
	
	collisionPolygon.polygon = vectorArray
	collisionPolygon.disabled = true
	staticBody.add_child(collisionPolygon)
	add_point(cableHead.position)

func start_electrification():
	electricityTimer.start()
	deelectrificationTimer.start()

func activate_collision():
	# Add a point to make sure that collision is all the way
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 
	add_cable_point(currentPoint, previousPoint)
	
	for child in staticBody.get_children():
		var collisionShape = child as CollisionPolygon2D
		collisionShape.disabled = false

func deactivate_collision():
	deelectrificationTimer.stop()
	if staticBody.get_child_count() > 0: 
		for child in staticBody.get_children():
			var childNode: Node = child
			staticBody.remove_child(childNode)
			childNode.queue_free()
	
	default_color = color
	var navRegion = get_node("/root/Main/NavigationRegion2D") as NavRegion
	navRegion.rebake_nav_polygon()

func _on_electricity_timer_timeout():
	activate_collision()
	blink()
	cable_electrified.emit()

func blink():
	default_color = Color.YELLOW

func _on_deelectrification_timer_timeout():
	deactivate_collision()
