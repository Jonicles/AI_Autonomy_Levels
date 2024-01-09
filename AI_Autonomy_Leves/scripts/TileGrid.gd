extends Node2D

var astarGrid: AStarGrid2D
# Called when the node enters the scene tree for the first time.
func _ready():
	astarGrid = AStarGrid2D.new()
	astarGrid.region = Rect2i(Vector2(0,0), Vector2(16,16))
	astarGrid.cell_size = Vector2i(48,48)
	astarGrid.update()
	astarGrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	print(astarGrid.default_compute_heuristic)
	print(astarGrid.get_id_path(Vector2i(0,0), Vector2i(4,1)))
