extends Area2D

class_name Item

func drop():
	var objects: Array[Area2D] = get_overlapping_areas()
	
	for i in objects:
		print(i.name)
