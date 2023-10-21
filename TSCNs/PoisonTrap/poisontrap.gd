extends Area2D

var tile: Vector2i
var type = "PoisonTrap"
var WorldMap
var enemies = []


func _physics_process(delta):
	for i in enemies:
		i.poison()

func areaEntered(area):
	var parent = area.get_parent()
	if "angry" in parent and area.name == "trapDetection":
		enemies.push_back(parent)

func areaExited(area):
	var parent = area.get_parent()
	if enemies.has(parent):
		enemies.erase(parent)
