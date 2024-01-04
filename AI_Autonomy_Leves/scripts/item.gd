class_name Item extends Area2D

var isGrabable: bool = true
signal grabbed_item

func drop():
	pass

func grab():
	grabbed_item.emit()

func make_grabable():
	isGrabable = true

func make_ungrabable():
	isGrabable = false
