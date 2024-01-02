class_name Item extends Area2D

var isGrabable: bool = true

func drop():
	pass

func grab():
	pass

func make_grabable():
	isGrabable = true

func make_ungrabable():
	isGrabable = false
