class_name CableConnectSnippet extends BehaviorSnippet

var points: int = 5

func evaluate_utiliy(ai: ArtificalIntelligence):
	var cablePointPairs: Array[CableConnectionPair]
	
	for greenCableHead in ai.grabableGreenCables:
		for connectionPoint in ai.connectionPointGreen:
			cablePointPairs.append(CableConnectionPair.new(greenCableHead, connectionPoint))
			
	for blueCableHead in ai.grabableBlueCables:
		for connectionPoint in ai.connectionPointBlue:
			cablePointPairs.append(CableConnectionPair.new(blueCableHead, connectionPoint))	
			
	for redCableHead in ai.grabableRedCables:
		for connectionPoint in ai.connectionPointRed:
			cablePointPairs.append(CableConnectionPair.new(redCableHead, connectionPoint))	
		
	if cablePointPairs.size() == 0:
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
		
		if pair.calculate_total_distance(ai.position) < shortestDistance:
			bestPair = pair
	
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
