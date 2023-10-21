extends Area2D

var tile: Vector2i
var type = "StickyTrap"
var WorldMap


func bodyEntered(body):
	print(body)
	print("enter")
	if "angry" in body:
		print("true")
		body.speed = 15

func bodyExited(body):
	print(body)
	print("exit")
	if "angry" in body:
		print("true")
		body.speed = 50
