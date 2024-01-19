class_name CableLine extends Line2D

@export var cableHead: Node2D
@export var color = Color.BLUE
@onready var staticBody: StaticBody2D = %StaticBody2D
@onready var electricityTimer: Timer = $ElectricityTimer

signal cable_electrified
signal cable_reset

var maxCableDistance = 128

func _ready():
	var navRegion = get_node("/root/Main/NavigationRegion2D") as NavRegion
	cable_electrified.connect(navRegion.rebake_nav_polygon)
	cable_reset.connect(navRegion.rebake_nav_polygon)
	
	reset_cable()
	
func reset_cable():
	clear_points()
	 
	if staticBody.get_child_count() > 0: 
		for child in staticBody.get_children():
			var childNode: Node = child
			staticBody.remove_child(childNode)
			childNode.queue_free()
	
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

func add_cable_point(currentPoint, previousPoint):
	var collisionPolygon: CollisionPolygon2D = CollisionPolygon2D.new()
	var vectorArray: Array[Vector2]
	vectorArray.append(currentPoint - Vector2(8, 8))
	vectorArray.append(previousPoint - Vector2(8, 8))
	vectorArray.append(previousPoint + Vector2(8, 8))
	vectorArray.append(currentPoint + Vector2(8, 8))	
	
	collisionPolygon.polygon = vectorArray
	collisionPolygon.disabled = true
	staticBody.add_child(collisionPolygon)
	add_point(cableHead.position)

func start_electrification():
	electricityTimer.start()

func activate_collision():
	# Add a point to make sure that collision is all the way
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 
	add_cable_point(currentPoint, previousPoint)
	
	for child in staticBody.get_children():
		var collisionShape = child as CollisionPolygon2D
		collisionShape.disabled = false

func _on_electricity_timer_timeout():
	activate_collision()
	blink()
	cable_electrified.emit()

func blink():
	default_color = Color.YELLOW
