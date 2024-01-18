extends Node2D

var astarGrid: AStarGrid2D
var batteryNode = load("res://scenes/battery.tscn")
var cellSize: int = 48

func _init():
	astarGrid = AStarGrid2D.new()
	astarGrid.cell_size = Vector2(cellSize, cellSize)
	astarGrid.region = Rect2i(Vector2(0,0), Vector2(41,23))
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	
	
	# TESTING
	#var currentBattery: Battery = batteryNode.instantiate()
	#var pos: Vector2 = find_closest_point(Vector2(288, 48))
	#print(pos)
	#currentBattery.global_position = pos
	#print(currentBattery.global_position)
	#
	#add_child(currentBattery)
	
func find_closest_point(position: Vector2):
	# Safe this so we cannot get outside of map
	
	var idVector = position / cellSize
	var flooredVector = idVector as Vector2i
	return astarGrid.get_point_position(flooredVector)
