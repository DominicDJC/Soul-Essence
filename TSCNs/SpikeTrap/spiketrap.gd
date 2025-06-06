extends Area2D

var WorldMap
var tile: Vector2i
var type = "SpikeTrap"
var cooldown = 7.5
var enemies = []


func _physics_process(delta):
	if cooldown > 0:
		cooldown -= delta
	elif enemies != []:
		attack()

func attack():
	cooldown = 7.5
	WorldMap.setTile(tile, "Spike2")
	for i in enemies:
		i.hurt(self, 10, 0, 0)
	await get_tree().create_timer(1).timeout
	WorldMap.setTile(tile, "Spike1")
	cooldown = 7.5

func areaEntered(area):
	var parent = area.get_parent()
	if "angry" in parent and area.name == "trapDetection":
		enemies.push_back(parent)

func areaExited(area):
	var parent = area.get_parent()
	if enemies.has(parent):
		enemies.erase(parent)
