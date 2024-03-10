class_name CableConnectSnippet extends BehaviorSnippet

var points: int = 5

func evaluate_utiliy(ai: ArtificalIntelligence):
	step = 1
	var cablePointPairs: Array[CableConnectionPair]
	
	for greenCableHead in ai.grabableGreenCables:
		ai.navigation_agent.target_position = greenCableHead.global_position
		var distanceToHead = ai.navigation_agent.distance_to_target()
		
		for connectionPoint in ai.connectionPointGreen.keys() as Array[Node2D]:
			var distanceToPoint = greenCableHead.global_position.distance_to(connectionPoint.global_position)
			cablePointPairs.append(CableConnectionPair.new(greenCableHead, connectionPoint, distanceToHead + distanceToPoint))
	
	for blueCableHead in ai.grabableBlueCables:
		ai.navigation_agent.target_position = blueCableHead.global_position
		var distanceToHead = ai.navigation_agent.distance_to_target()
		
		for connectionPoint in ai.connectionPointBlue.keys() as Array[Node2D]:
			var distanceToPoint = blueCableHead.global_position.distance_to(connectionPoint.global_position)
			cablePointPairs.append(CableConnectionPair.new(blueCableHead, connectionPoint, distanceToHead + distanceToPoint))
	
	for redCableHead in ai.grabableRedCables:
		ai.navigation_agent.target_position = redCableHead.global_position
		var distanceToHead = ai.navigation_agent.distance_to_target()
		
		for connectionPoint in ai.connectionPointRed.keys() as Array[Node2D]:
			var distanceToPoint = redCableHead.global_position.distance_to(connectionPoint.global_position)
			cablePointPairs.append(CableConnectionPair.new(redCableHead, connectionPoint, distanceToHead + distanceToPoint))

	if cablePointPairs.size() == 0:
		ai.navigation_agent.target_position = ai.global_position
		return 0
	
	var bestPair: CableConnectionPair
	var shortestDistance: float = INF
	
	for pair in cablePointPairs:
		ai.navigation_agent.target_position = pair.cableHead.global_position
		
		if not ai.navigation_agent.is_target_reachable():
			continue
			
		ai.navigation_agent.target_position = pair.connectionPoint.global_position
			
		if not ai.navigation_agent.is_target_reachable():
			continue
		
		if pair.distance < shortestDistance:
			bestPair = pair
			shortestDistance = pair.distance
	
	if bestPair == null:
		ai.navigation_agent.target_position = ai.global_position
		return 0
	
	itemTarget = bestPair.cableHead.global_position
	destination = bestPair.connectionPoint.global_position
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

func cancel_behavior():
	step = 5
