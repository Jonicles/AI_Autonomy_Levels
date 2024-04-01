class_name LowAutonomyAI extends ArtificalIntelligence

var batteryPlaceSolo = BatteryPlaceSolo.new()
var batteryRecycleSolo = BatteryRecycleSolo.new()
var cableConnectSolo = CableConnectSolo.new()
var batteryPlaceAssist = BatteryPlaceAssist.new()
var batteryRecycleAssist = BatteryRecycleAssist.new()



func _input(event):
	if event.is_action_pressed("Player_1"):
		reset()
		currentSnippet = batteryPlaceSolo
		print("Place Solo Snippet")
		
	if event.is_action_pressed("Player_2"):
		reset()
		currentSnippet = batteryRecycleSolo
		print("Recycle Solo Snippet")
		
	if event.is_action_pressed("Player_3"):
		reset()
		currentSnippet = cableConnectSolo
		print("Connect Solo Snippet")
	if event.is_action_pressed("Player_4"):
		reset()
		currentSnippet = batteryPlaceAssist
		print("Place Assit Snippet")
	if event.is_action_pressed("Player_5"):
		reset()
		currentSnippet = batteryRecycleAssist
		print("Recycle Assist Snippet")
	#if event.is_action_pressed("Player_6"):
		#reset()
		#currentSnippet = batteryPlaceAssist
		#print("Connect Snippet")
	
