extends Node2D

@export var combinedLabel: Label
@export var playerLabel: Label
@export var aiLabel: Label

func _ready():
	var playerScore = GlobalScores.get_score("Player")
	var aiScore = GlobalScores.get_score("AI")
	
	combinedLabel.text = "Combined score: " + encrypt_score(playerScore + aiScore)
	playerLabel.text = "Player score: " + encrypt_score(playerScore)
	aiLabel.text = "AI score: " + encrypt_score(aiScore)

func encrypt_score(score: int):
	var scoreString: String = str(score) 
	var key: String = "ARSTGMNEIO"
	var result: String = ""
	
	for char in scoreString:
		var index = char as int
		result += key[index]
	
	return result
