class_name HighAutonomyAi extends ArtificalIntelligence

var batteryPlaceSolo = BatteryPlaceSolo.new()
var batteryRecycleSolo = BatteryRecycleSolo.new()
var cableConnectSolo = CableConnectSolo.new()
var batteryPlaceAssist = BatteryPlaceAssist.new()
var batteryRecycleAssist = BatteryRecycleAssist.new()
var cableConnectAssist = CableConnectAssist.new()

func try_get_next_task():
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
	var snippetsToEvaluate: Array[BehaviorSnippet] = [
		batteryPlaceSolo, batteryRecycleSolo, cableConnectSolo, batteryPlaceAssist, batteryRecycleAssist, cableConnectAssist]
	
	var highestUtility = -INF
	var bestSnippet: BehaviorSnippet
	
	for snippet in snippetsToEvaluate:
		var currentUtility = snippet.evaluate_utility(self) 
		
		if currentUtility > highestUtility:
			bestSnippet = snippet
			highestUtility = currentUtility
			
	currentSnippet = bestSnippet
	
	match currentSnippet:
		batteryPlaceSolo:
			iconSwitcher.set_action_icon("Battery")
			iconSwitcher.set_mode_icon("Solo")
		batteryPlaceAssist:
			iconSwitcher.set_action_icon("Battery")
			iconSwitcher.set_mode_icon("Assist")
		batteryRecycleSolo:
			iconSwitcher.set_action_icon("Recycle")
			iconSwitcher.set_mode_icon("Solo")			
		batteryRecycleAssist:
			iconSwitcher.set_action_icon("Recycle")
			iconSwitcher.set_mode_icon("Assist")
		cableConnectSolo:
			iconSwitcher.set_action_icon("Cable")
			iconSwitcher.set_mode_icon("Solo")
		cableConnectAssist:
			iconSwitcher.set_action_icon("Cable")
			iconSwitcher.set_mode_icon("Assist")
		_:
			pass
	
	return highestUtility
