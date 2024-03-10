class_name LowAutonomyAI extends ArtificalIntelligence

func _input(event):
	if event.is_action_pressed("Player_1"):
		currentSnippet = BatteryPlaceSnippet.new()
		print("Place Snippet")
		
	if event.is_action_pressed("Player_2"):
		currentSnippet = BatteryRecycleSnippet.new()
		print("Recycle Snippet")
		
	
	if event.is_action_pressed("Player_3"):
		currentSnippet = CableConnectSnippet.new()
		print("Connect Snippet")
