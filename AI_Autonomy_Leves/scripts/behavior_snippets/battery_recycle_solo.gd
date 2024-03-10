class_name BatteryRecycleSnippet extends BehaviorSnippet

var points: int = 5

func evaluate_utiliy(ai: ArtificalIntelligence):
	step = 1
	if ai.grabableEmptyBatteries.size() == 0:
		return 0
		
	var currentBattery: Battery
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
	
	itemTarget = currentBattery.global_position
	destination = ai.recyclePoint.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	match step:
		1:
			ai.navigation_agent.target_position = itemTarget
			step += 1
		2:
			if not ai.navigation_agent.is_navigation_finished():
				ai.move()
				return
			
			ai.grab()
			step += 1
		3:
			ai.navigation_agent.target_position = destination
			step += 1
		4:
			if not ai.navigation_agent.is_navigation_finished():
				ai.move()
				return
			
			ai.drop()
			step += 1
		_:
			print("Task Complete!")
			ai.reset()

func cancel_behavior():
	step = 5
