extends Node2D

@onready var Arrow = $Arrow
@onready var Area = $Area2D
var enemies = []
var cooldown = 0.0
var health = 75
var rotations = 0
var tile: Vector2i
var type = "Directional"
var WorldMap: TileMap


func _physics_process(delta):
	if cooldown > 0:
		cooldown -= delta
	elif enemies != []:
		fire()

func doRotate():
	if rotations < 270:
		rotations += 90
	else:
		rotations = 0
	Arrow.update(rotations)
	Area.rotation_degrees = rotations

func fire():
	for i in enemies:
		i.lightHurt(5)
	cooldown = 5

func bodyEntered(body):
	if "angry" in body:
		enemies.push_back(body)

func bodyExited(body):
	if enemies.has(body):
		enemies.erase(body)
