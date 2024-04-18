class_name ScoreKeeper extends Node

@export var dictionaryKey: String
var currentPoints: int = 0

func add_score(pointsToAdd: int):
	currentPoints += pointsToAdd
	print(dictionaryKey + " current points updated! Now: " + str(currentPoints))
	GlobalScores.update_score(dictionaryKey, currentPoints)
