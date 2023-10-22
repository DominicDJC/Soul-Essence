extends Node2D

var type = "Wall"
var tile: Vector2i
var health
var WorldMap


func hurt(source, damage := 5):
	health -= damage
	if health <= 0:
		WorldMap.enemyKillTile(tile, null, self)
