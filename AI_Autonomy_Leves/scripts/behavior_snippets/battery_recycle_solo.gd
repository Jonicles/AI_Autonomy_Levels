class_name BatteryRecycleSolo extends BehaviorSnippet

var points: int = 3
var currentBattery: Battery

func evaluate_utility(ai: ArtificalIntelligence):
	currentBattery = null
	step = 1
	
	if ai.grabableEmptyBatteries.size() == 0:
		return 0
		
	var shortestDistance: float = INF
	for battery in ai.grabableEmptyBatteries:
		ai.navigation_agent.target_position = battery.global_position
		
		if not ai.navigation_agent.is_target_reachable():
			continue
		
		var currentDistance: float = battery.global_position.distance_to(ai.global_position) 
		if  currentDistance < shortestDistance:
			currentBattery = battery
			shortestDistance = currentDistance
	
	if currentBattery == null:
		return 0
		
	ai.navigation_agent.target_position = ai.recyclePoint.global_position
	if not ai.navigation_agent.is_target_reachable():
		return 0
	
	if not currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.connect(cancel_behavior)
	
	itemTarget = currentBattery.global_position
	destination = ai.recyclePoint.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	match step:
		1:
			print("Runnint Battery Recycle Solo")
			ai.navigation_agent.target_position = itemTarget
			step += 1
		2:
			if not ai.navigation_agent.is_navigation_finished():
				if not ai.navigation_agent.is_target_reachable():
					ai.reset()
					return
						
				ai.move()
				return
				
			currentBattery.grabbed_item.disconnect(cancel_behavior)
			ai.grab()
			step += 1
		3:
			ai.navigation_agent.target_position = destination
			step += 1
		4:
			if not ai.navigation_agent.is_navigation_finished():
				if not ai.navigation_agent.is_target_reachable():
					ai.reset()
					return
					
				ai.move()
				return
			
			ai.drop()
			step += 1
		_:
			print("Task Complete!")
			ai.reset()

func cancel_behavior(_node):
	if currentBattery != null && currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.disconnect(cancel_behavior)
	step = 5
