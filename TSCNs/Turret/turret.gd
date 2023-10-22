extends Area2D

var cooldown = 0.0
var enemies = []
var health = 80
var tile: Vector2i
var type = "Turret"
var WorldMap: TileMap


func _physics_process(delta):
	if cooldown > 0:
		cooldown -= delta
	elif enemies != []:
		fire()

func fire():
	var closest = enemies[0]
	for i in enemies.size() - 1:
		if position.distance_to(enemies[i].position) < position.distance_to(closest.position):
			closest = enemies[i]
	closest.lightHurt(10)
	cooldown = 5

func bodyEntered(body):
	if "angry" in body:
		enemies.push_back(body)

func bodyExited(body):
	if enemies.has(body):
		enemies.erase(body)

func hurt(source, damage := 5):
	health -= damage
	if health < 0:
		WorldMap.enemyKillTile(tile, source, self)
