extends Node2D

@onready var WorldMap = $"../WorldMap"
@onready var Enemy = preload("res://TSCNs/Enemy/enemy.tscn")
@onready var DroppedItems = $"../DroppedItems"


func _ready():
	createEnemy(Vector2(0, 0))

func createEnemy(pos):
	var e = Enemy.instantiate()
	e.position = pos
	e.WorldMap = WorldMap
	e.DroppedItems = DroppedItems
	add_child(e)
