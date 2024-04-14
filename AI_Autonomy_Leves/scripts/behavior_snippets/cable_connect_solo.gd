class_name CableConnectSolo extends BehaviorSnippet

var points: int = 1
var currentCableHead: CableHead
var currentConnectionPoint: DropZoneCable

func evaluate_utility(ai: ArtificalIntelligence):
	currentCableHead = null
	
	step = 1
	var cablePointPairs: Array[CableConnectionPair]
	
	var redConnectionpoints: Array[DropZoneCable]
	var blueConnectionpoints: Array[DropZoneCable] 
	var greenConnectionpoints: Array[DropZoneCable] 
	
	for key in ai.connectionPointRed.keys():
		redConnectionpoints.append(key as DropZoneCable)
	for key in ai.connectionPointBlue.keys():
		blueConnectionpoints.append(key as DropZoneCable)
	for key in ai.connectionPointGreen.keys():
		greenConnectionpoints.append(key as DropZoneCable)
		
	
		
	redConnectionpoints = remove_unreachable_connections(ai, ai.grabableRedCables, redConnectionpoints)
	blueConnectionpoints = remove_unreachable_connections(ai, ai.grabableBlueCables, blueConnectionpoints)
	greenConnectionpoints = remove_unreachable_connections(ai, ai.grabableGreenCables, greenConnectionpoints)
	
	redConnectionpoints = evaluate_connection_priority(redConnectionpoints)
	blueConnectionpoints = evaluate_connection_priority(blueConnectionpoints)
	greenConnectionpoints = evaluate_connection_priority(greenConnectionpoints)
	
	cablePointPairs = find_shortest_distance(ai, redConnectionpoints, blueConnectionpoints, greenConnectionpoints)

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
	
	currentCableHead = bestPair.cableHead as CableHead
	if not currentCableHead.grabbed_item.is_connected(cancel_behavior):
		currentCableHead.grabbed_item.connect(cancel_behavior)
	
	currentConnectionPoint = bestPair.connectionPoint as DropZoneCable
	if not currentConnectionPoint.point_connected.is_connected(cancel_behavior):
		currentConnectionPoint.point_connected.connect(cancel_behavior)
	
	itemTarget = bestPair.cableHead.global_position
	destination = bestPair.connectionPoint.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	match step:
		1:
			print("Runnint Cable Solo")
			ai.navigation_agent.target_position = itemTarget
			step += 1
		2:
			if not ai.navigation_agent.is_navigation_finished():
				if not ai.navigation_agent.is_target_reachable():
					ai.reset()
					return
				
				ai.move()
				return
				
			currentCableHead.grabbed_item.disconnect(cancel_behavior)
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
			
			currentConnectionPoint.point_connected.disconnect(cancel_behavior)
			ai.drop()
			step += 1
		_:
			print("Task Complete!")
			ai.reset()

func cancel_behavior(_node):
	if currentCableHead != null && currentCableHead.grabbed_item.is_connected(cancel_behavior):
		currentCableHead.grabbed_item.disconnect(cancel_behavior)
	if currentConnectionPoint != null && currentConnectionPoint.point_connected.is_connected(cancel_behavior):
		currentConnectionPoint.point_connected.disconnect(cancel_behavior)
	step = 5

func remove_unreachable_connections(ai: ArtificalIntelligence, cableHeads: Array[CableHead], connectionPoints: Array[DropZoneCable]):
	var availableConnectionPoints: Array[DropZoneCable]
	
	for cableHead in cableHeads:
		ai.navigation_agent.target_position = cableHead.global_position
		if not ai.navigation_agent.is_target_reachable():
			continue
			
		for point in connectionPoints:
			ai.navigation_agent.target_position = point.global_position
			if not ai.navigation_agent.is_target_reachable():
				continue
			# Ai will not try to go to the same connection point as player
			if point == currentConnectionPoint:
				continue
				
			availableConnectionPoints.append(point)
		# There is no need to evaluate more the connection point again if we have a connection
		break
		
	return availableConnectionPoints

func evaluate_connection_priority(connectionPoints: Array[DropZoneCable]):
	var highestPriorityPoints: Array[DropZoneCable]
	var currentHighestPriority: int = -INF
	
	for point in connectionPoints:
		var priority = point.connectionPriority
		
		if priority == currentHighestPriority:
			highestPriorityPoints.append(point)
		elif priority > currentHighestPriority:
			highestPriorityPoints.clear()
			highestPriorityPoints.append(point)
			currentHighestPriority = priority
	
	# The points within the list will always have the same amount of priority
	return highestPriorityPoints

func find_shortest_distance(ai: ArtificalIntelligence,redPoints: Array[DropZoneCable], bluePoints: Array[DropZoneCable], greenPoints: Array[DropZoneCable]):
	var isGreenEmpty: bool = greenPoints.size() == 0
	var isRedEmpty: bool = redPoints.size() == 0
	var isBlueEmpty: bool = bluePoints.size() == 0
	
	var skipRedEvaluation: bool = (
		isRedEmpty
		or (!isBlueEmpty && redPoints[0].connectionPriority < bluePoints[0].connectionPriority)
		or (!isGreenEmpty && redPoints[0].connectionPriority < greenPoints[0].connectionPriority)
	)
	
	var skipBlueEvaluation: bool = (
		isBlueEmpty 
		or (!isRedEmpty && bluePoints[0].connectionPriority < redPoints[0].connectionPriority)
		or (!isGreenEmpty && bluePoints[0].connectionPriority < greenPoints[0].connectionPriority)
	)
	
	var skipGreenEvaluation: bool = (
		isGreenEmpty
		or (!isRedEmpty && greenPoints[0].connectionPriority < redPoints[0].connectionPriority)
		or (!isBlueEmpty && greenPoints[0].connectionPriority < bluePoints[0].connectionPriority)
	)
	
	var cablePointPairs: Array[CableConnectionPair]	
	
	if not skipRedEvaluation:
		for redCableHead in ai.grabableRedCables:
			ai.navigation_agent.target_position = redCableHead.global_position
			var distanceToHead = ai.navigation_agent.distance_to_target()
		
			for connectionPoint in redPoints as Array[Node2D]:
				var distanceToPoint = redCableHead.global_position.distance_to(connectionPoint.global_position)
				cablePointPairs.append(CableConnectionPair.new(redCableHead, connectionPoint, distanceToHead + distanceToPoint))
	
	if not skipGreenEvaluation:
		for greenCableHead in ai.grabableGreenCables:
			ai.navigation_agent.target_position = greenCableHead.global_position
			var distanceToHead = ai.navigation_agent.distance_to_target()
			
			for connectionPoint in greenPoints as Array[Node2D]:
				var distanceToPoint = greenCableHead.global_position.distance_to(connectionPoint.global_position)
				cablePointPairs.append(CableConnectionPair.new(greenCableHead, connectionPoint, distanceToHead + distanceToPoint))
	
	if not skipBlueEvaluation:
		for blueCableHead in ai.grabableBlueCables:
			ai.navigation_agent.target_position = blueCableHead.global_position
			var distanceToHead = ai.navigation_agent.distance_to_target()
			
			for connectionPoint in bluePoints as Array[Node2D]:
				var distanceToPoint = blueCableHead.global_position.distance_to(connectionPoint.global_position)
				cablePointPairs.append(CableConnectionPair.new(blueCableHead, connectionPoint, distanceToHead + distanceToPoint))
				
	return cablePointPairs
