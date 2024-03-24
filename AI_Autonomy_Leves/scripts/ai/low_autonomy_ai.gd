class_name LowAutonomyAI extends ArtificalIntelligence

var batteryPlaceSolo = BatteryPlaceSolo.new()
var batteryRecycleSolo = BatteryRecycleSolo.new()
var cableConnectSolo = CableConnectSolo.new()
var batteryPlaceAssist = BatteryPlaceAssist.new()


func _input(event):
	if event.is_action_pressed("Player_1"):
		reset()
		currentSnippet = batteryPlaceSolo
		print("Place Snippet")
		
	if event.is_action_pressed("Player_2"):
		reset()
		currentSnippet = batteryRecycleSolo
		print("Recycle Snippet")
		
	if event.is_action_pressed("Player_3"):
		reset()
		currentSnippet = cableConnectSolo
		print("Connect Snippet")
	if event.is_action_pressed("Player_4"):
		reset()
		currentSnippet = batteryPlaceAssist
		print("Connect Snippet")
	
