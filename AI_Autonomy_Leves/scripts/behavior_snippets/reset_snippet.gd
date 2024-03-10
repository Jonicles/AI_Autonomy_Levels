class_name ResetSnippet extends BehaviorSnippet

var points: int = 5

func evaluate_utiliy(ai: ArtificalIntelligence):
	itemTarget = ai.centerPoint.global_position
	return points
	
func run_behavior(ai: ArtificalIntelligence):
	match step:
		1:
			ai.navigation_agent.target_position = itemTarget
			step += 1
		2:
			if not ai.navigation_agent.is_navigation_finished():
				ai.move()
			else:
				step += 1
		_:
			ai.currentSnippet = null
			ai.utility = 0
