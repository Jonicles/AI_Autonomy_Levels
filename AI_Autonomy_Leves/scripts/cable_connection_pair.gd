class_name CableConnectionPair extends Node

var cableHead: Node2D
var connectionPoint: Node2D

func _init(head, point):
	cableHead = head
	connectionPoint = point

func calculate_total_distance(position: Vector2):
	var distance = 0
	distance += position.distance_to(cableHead.global_position)
	distance += cableHead.position.distance_to(connectionPoint.global_position)
	return distance
