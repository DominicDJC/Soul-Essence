extends Area2D

var tile: Vector2i
var type = "StickyTrap"
var WorldMap


func areaEntered(area):
	var parent = area.get_parent()
	if "angry" in parent and area.name == "trapDetection":
		parent.speed = 15

func areaExited(area):
	var parent = area.get_parent()
	if "angry" in parent and area.name == "trapDetection":
		parent.speed = 50
