class_name BatteryPlaceSnippet extends BehaviorSnippet

func evaluate_utiliy(ai: ArtificalIntelligence):
	if ai.grabableBatteries.size() == 0:
		return 0
		
	if ai.emptyPylons.size() == 0:
		return 0
	
	var currentBattery: Battery
	var shortestDistance: float = INF
	
	for battery in ai.grabableBatteries:
		ai.navigation_agent.target_position = battery.global_position
		
		if not ai.navigation_agent.is_target_reachable():
			continue
		
		if battery.global_position.distance_to(ai.global_position) < shortestDistance:
			currentBattery = battery
			
	if currentBattery == null:
		ai.navigation_agent.target_position = ai.global_position
		return 0
	
	var currentPylon: BatteryPylon
	shortestDistance = INF
	
	for pylon in ai.emptyPylons:
		ai.navigation_agent.target_position = pylon.global_position
		
		if not ai.navigation_agent.is_target_reachable():
			print("not reachable")
			continue
		
		if pylon.global_position.distance_to(ai.global_position) < shortestDistance:
			currentPylon = pylon
			
	if currentPylon == null:
		ai.navigation_agent.target_position = ai.global_position
		return 0
	
	itemTarget = currentBattery.global_position
	destination = currentPylon.global_position
	return 5
	
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
		5:
			print("Task Complete!")
			ai.reset()
