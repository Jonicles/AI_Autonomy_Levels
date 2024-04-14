class_name BatteryRecycleAssist extends BehaviorSnippet

var points: int = 6
var currentBattery: Battery

func evaluate_utility(ai: ArtificalIntelligence):
	currentBattery = null
	step = 1
	
	if ai.grabableEmptyBatteries.size() == 0:
		return 0
		
	ai.navigation_agent.target_position = ai.player.global_position
	if ai.navigation_agent.is_target_reachable():
		return 0
		
	ai.navigation_agent.target_position = ai.recyclePoint.global_position
	if ai.navigation_agent.is_target_reachable():
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
		
	if not currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.connect(cancel_behavior)
	
	itemTarget = currentBattery.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	ai.player.navigationAgent.target_position = ai.global_position
	if ai.player.navigationAgent.is_target_reachable():
		cancel_behavior(self)
		
	match step:
		1:
			print("Runnint Battery Recycle Assist")
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
			
			ai.navigation_agent.target_position = ai.global_position
			
			step += 1
		4:
			var direction = ai.player.global_position - ai.global_position
			ai.controller.change_direction(direction.normalized())
			ai.throw()
			ai.controller.change_direction(Vector2.ZERO)
			step += 1
		_:
			print("Task Complete!")
			ai.reset()

func cancel_behavior(_node):
	if currentBattery != null && currentBattery.grabbed_item.is_connected(cancel_behavior):
		currentBattery.grabbed_item.disconnect(cancel_behavior)
	step = 5
