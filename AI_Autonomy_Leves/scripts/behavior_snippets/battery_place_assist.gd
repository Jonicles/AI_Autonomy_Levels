class_name BatteryPlaceAssist extends BehaviorSnippet

var points: int = 5
var currentBattery: Battery

func evaluate_utiliy(ai: ArtificalIntelligence):
	currentBattery = null
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
	
	ai.navigation_agent.target_position = ai.player.global_position
	
	if ai.navigation_agent.is_target_reachable():
		return 0
	
	if not currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.connect(cancel_behavior)
	
	ai.navigation_agent.target_position = ai.global_position
	itemTarget = currentBattery.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	if ai.emptyPylons.size() == 0:
		cancel_behavior(self)
		ai.reset()
			
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
			ai.navigation_agent.target_position = ai.player.global_position
			
			if not ai.navigation_agent.is_navigation_finished():
				ai.move()
				return
				
			ai.throw()
			step += 1
		_:
			print("Task Complete!")
			ai.reset()

func cancel_behavior(_node):
	if currentBattery != null && currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.disconnect(cancel_behavior)
