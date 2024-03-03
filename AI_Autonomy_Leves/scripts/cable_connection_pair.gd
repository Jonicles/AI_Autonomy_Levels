class_name CableConnectionPair extends Node

var distance: float
var cableHead: Node2D
var connectionPoint: Node2D

func _init(head, point, totalDistance):
	distance = totalDistance
	cableHead = head
	connectionPoint = point
