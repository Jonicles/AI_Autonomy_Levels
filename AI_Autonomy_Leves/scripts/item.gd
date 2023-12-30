extends Area2D

class_name Item

var isGrabable: bool = true

func drop():
	pass

func make_grabable():
	isGrabable = true

func make_ungrabable():
	isGrabable = false
