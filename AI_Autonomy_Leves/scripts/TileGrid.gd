extends Node2D

@onready var line: Line2D = $Line2D
var astarGrid: AStarGrid2D


func _ready():
	var cellDimension = 48
	astarGrid = AStarGrid2D.new()
	astarGrid.cell_size = Vector2(cellDimension, cellDimension)
	astarGrid.region = Rect2i(Vector2(0,0), Vector2(41,23))
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astarGrid.update()
	
	line.position = Vector2(cellDimension, cellDimension) * 0.5
	
	var paths_points: Array = astarGrid.get_point_path(Vector2i(0,0), Vector2i(40,22))
	for i in paths_points:
		line.add_point(i)
		
	find_closest_point(Vector2(96,0))
	
func find_closest_point(position: Vector2):
	var idVector = position / 48
	var flooredVector = idVector as Vector2i
	
	return astarGrid.get_point_position(flooredVector)
