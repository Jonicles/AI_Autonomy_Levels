extends Node

var score_dictionary: Dictionary = {}

func update_score(scoreKey: String, newScore):
	score_dictionary[scoreKey] = newScore

func get_score(scoreKey: String):
	if not score_dictionary.has(scoreKey):
		print("No score for this key...")
		return 0
		
	return score_dictionary[scoreKey]
