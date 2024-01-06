extends Line2D

@export var cableHead: Node2D
var cableOffest = Vector2(24,0)
var maxCableDistance = 72
var minPickupDistance = 56


func _ready():
	reset_cable()

func reset_cable():
	clear_points()
	
	var startPostion = position + cableOffest
	add_point(startPostion)
	add_point(startPostion)

func _process(delta):
	try_add_point()
	#try_remove_point()
	points[points.size() - 1] = cableHead.position + cableOffest

func try_add_point():
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 
	
	if currentPoint.distance_to(previousPoint) > maxCableDistance:
		add_point(cableHead.position + cableOffest)

func try_remove_point():
	if points.size() < 3:
		return
	
	var currentPoint = points[points.size() - 1] 
	var previousPoint = points[points.size() - 2] 
	
	if currentPoint.distance_to(previousPoint) < maxCableDistance:
		remove_point(points.size() - 1)

func _on_cable_left_cable_disconnect():
	reset_cable()
