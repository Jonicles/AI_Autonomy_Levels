class_name MediumAutonomyAi extends ArtificalIntelligence

var batteryPlaceSolo = BatteryPlaceSolo.new()
var batteryRecycleSolo = BatteryRecycleSolo.new()
var cableConnectSolo = CableConnectSolo.new()
var batteryPlaceAssist = BatteryPlaceAssist.new()
var batteryRecycleAssist = BatteryRecycleAssist.new()
var cableConnectAssist = CableConnectAssist.new()

var assistModeActive: bool = false

func try_get_next_task():
	print("Tryint to get next task...")
	utility = get_best_behaviour()
	
	if utility == 0:
		navigation_agent.target_position = centerPoint.global_position
		move()

func _process(_delta):
	if utility == 0:
		try_get_next_task()
		return
		
	currentSnippet.run_behavior(self)

func get_best_behaviour():
	var snippetsToEvaluate: Array[BehaviorSnippet]
	
	if assistModeActive:
		snippetsToEvaluate = [batteryPlaceAssist, batteryRecycleAssist, cableConnectAssist]
	else:
		snippetsToEvaluate = [batteryPlaceSolo, batteryRecycleSolo, cableConnectSolo]
		
	var highestUtility = -INF
	var bestSnippet: BehaviorSnippet
	
	for snippet in snippetsToEvaluate:
		var currentUtility = snippet.evaluate_utility(self) 
		
		if currentUtility > highestUtility:
			bestSnippet = snippet
			highestUtility = currentUtility
			
	currentSnippet = bestSnippet
	return highestUtility

func _input(event):
	if event.is_action_pressed("Player_4"):
		currentSnippet.cancel_behavior
		reset()
		
		if assistModeActive:
			assistModeActive = false
			print("Solo Mode Activated")
		else:
			assistModeActive = true
			print("Assist Mode Activated")
