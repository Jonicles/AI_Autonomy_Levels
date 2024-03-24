class_name NavRegion extends NavigationRegion2D

@onready var timer: Timer = $Timer
var isBaking = false

func _ready():
	var truckSpawner = $TruckSpawner as TruckSpawner
	truckSpawner.truck_spawned.connect(_on_truck_spawned)
	bake_finished.connect(_on_bake_finished)
	timer.timeout.connect(_on_timer_timeout)

func rebake_nav_polygon():
	if isBaking:
		return
		
	isBaking = true
	bake_navigation_polygon()

func _on_truck_spawned(_truck):
	rebake_nav_polygon()
	
func _on_truck_despawned():
	timer.start() 
	
func _on_timer_timeout():
	rebake_nav_polygon()

func _on_bake_finished():
	isBaking = false
