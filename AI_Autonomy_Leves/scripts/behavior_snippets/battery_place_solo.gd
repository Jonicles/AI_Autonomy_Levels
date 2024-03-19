class_name BatteryPlaceSnippet extends BehaviorSnippet

var points: int = 5
var currentBattery: Battery
var currentPylon: BatteryPylon

func evaluate_utiliy(ai: ArtificalIntelligence):
	currentBattery = null
	currentPylon = null
	step = 1
	
	if ai.grabableBatteries.size() == 0:
		return 0
		
	if ai.emptyPylons.size() == 0:
		return 0
	
	
	var shortestDistance: float = INF
	for battery in ai.grabableBatteries:
		ai.navigation_agent.target_position = battery.global_position
		
		if not ai.navigation_agent.is_target_reachable():
			continue
		
		var distanceToTarget: float  = ai.navigation_agent.distance_to_target()
		if  distanceToTarget < shortestDistance:
			currentBattery = battery
			shortestDistance = distanceToTarget
	
	if currentBattery == null:
		ai.navigation_agent.target_position = ai.global_position
		return 0
	
	
	shortestDistance = INF
	for pylon in ai.emptyPylons:
		ai.navigation_agent.target_position = pylon.global_position
		
		if not ai.navigation_agent.is_target_reachable():
			continue
			
		var currentDistance: float = pylon.global_position.distance_to(currentBattery.global_position) 
		if  currentDistance < shortestDistance:
			currentPylon = pylon
			shortestDistance = currentDistance
	
	if currentPylon == null:
		ai.navigation_agent.target_position = ai.global_position
		return 0
	
	if not currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.connect(cancel_behavior)
		
	if not currentPylon.battery_insert.is_connected(cancel_behavior):
		currentPylon.battery_insert.connect(cancel_behavior)
	
	itemTarget = currentBattery.global_position
	destination = currentPylon.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	match step:
		1:
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
			
			currentPylon.battery_insert.disconnect(cancel_behavior)
			ai.drop()
			step += 1
		_:
			print("Task Complete!")
			ai.reset()

func cancel_behavior(_node):
	if currentBattery != null && currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.disconnect(cancel_behavior)
	if currentPylon != null && currentPylon.battery_insert.is_connected(cancel_behavior):
		currentPylon.battery_insert.disconnect(cancel_behavior)
	step = 5
