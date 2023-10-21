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

func bodyEntered(body):
	if "angry" in body:
		enemies.push_back(body)

func bodyExited(body):
	if enemies.has(body):
		enemies.erase(body)

func attack():
	cooldown = 7.5
	WorldMap.setTile(tile, "Spike2")
	for i in enemies:
		i.hurt(self, 10, 0, 0)
	await get_tree().create_timer(1).timeout
	WorldMap.setTile(tile, "Spike1")
	cooldown = 7.5
