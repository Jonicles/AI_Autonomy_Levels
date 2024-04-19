class_name LowAutonomyAI extends ArtificalIntelligence

var batteryPlaceSolo = BatteryPlaceSolo.new()
var batteryRecycleSolo = BatteryRecycleSolo.new()
var cableConnectSolo = CableConnectSolo.new()
var batteryPlaceAssist = BatteryPlaceAssist.new()
var batteryRecycleAssist = BatteryRecycleAssist.new()
var cableConnectAssist = CableConnectAssist.new()

var assistModeActive: bool = false

func _input(event):
	if event.is_action_pressed("Player_1"):
		reset()
		iconSwitcher.set_action_icon("Battery")
		
		if assistModeActive:
			currentSnippet = batteryPlaceAssist
			print("Place Assist Snippet")			
		else:
			currentSnippet = batteryPlaceSolo
			print("Place Solo Snippet")
		
	if event.is_action_pressed("Player_2"):
		reset()
		iconSwitcher.set_action_icon("Recycle")		
		
		if assistModeActive:
			currentSnippet = batteryRecycleAssist
			print("Recycle Assist Snippet")
		else:
			currentSnippet = batteryRecycleSolo
			print("Recycle Solo Snippet")			
		
	if event.is_action_pressed("Player_3"):
		reset()
		iconSwitcher.set_action_icon("Cable")
		
		if assistModeActive:
			currentSnippet = cableConnectAssist
			print("Connect Assist Snippet")
		else:
			currentSnippet = cableConnectSolo
			print("Connect Solo Snippet")
		
	if event.is_action_pressed("Player_4"):
		if currentSnippet == null:
			return
			
		reset()
		var previousBehaviour = currentSnippet as BehaviorSnippet
		var newBehaviour: BehaviorSnippet
		
		if assistModeActive:
			print("Switchinig to Solo mode")
			assistModeActive = false
			iconSwitcher.set_mode_icon("Solo")			
			match currentSnippet:
				batteryPlaceAssist:
					newBehaviour = batteryPlaceSolo
				batteryRecycleAssist:
					newBehaviour = batteryRecycleSolo
				cableConnectAssist:
					newBehaviour = cableConnectSolo
		else:
			print("Switchinig to Assist mode")			
			assistModeActive = true
			iconSwitcher.set_mode_icon("Assist")
			match currentSnippet:
				batteryPlaceSolo:
					newBehaviour = batteryPlaceAssist
				batteryRecycleSolo:
					newBehaviour = batteryRecycleAssist
				cableConnectSolo:
					newBehaviour = cableConnectAssist
		
		previousBehaviour.cancel_behavior(self)
		currentSnippet = newBehaviour
