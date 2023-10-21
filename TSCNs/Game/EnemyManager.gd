extends Node2D

@onready var WorldMap = $"../WorldMap"
@onready var Enemy = preload("res://TSCNs/Enemy/enemy.tscn")
@onready var DroppedItems = $"../DroppedItems"
@onready var Player = $"../Player"
@onready var Portal = $"../Portal"
var maxEnemies = 3
var spawnCooldown = 10.0
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()

func _physics_process(delta):
	if G.nightDay == "Night":
		if spawnCooldown > 0:
			spawnCooldown -= delta
		else:
			spawnEnemy()
			spawnCooldown = 10.0

func spawnEnemy():
	var pos = Vector2(0, 0)
	pos.x = (-200 if rng.randi_range(0, 1) == 0 else 650) + rng.randi_range(0, 100)
	pos.y = rng.randi_range(-100, 500)
	createEnemy(pos)

func createEnemy(pos):
	var e = Enemy.instantiate()
	e.position = pos
	e.WorldMap = WorldMap
	e.DroppedItems = DroppedItems
	e.Player = Player
	e.Portal = Portal
	add_child(e)

func getLeftRight():
	var array = []
	for i in get_children():
		if i.name == "Left" or i.name == "Right":
			array.push_back(i)
	return array
