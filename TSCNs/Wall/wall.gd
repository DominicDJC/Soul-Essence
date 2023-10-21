extends Node2D

var type = "Wall"
var tile: Vector2i
var health = 0
var WorldMap


func hurt(source, damage := 5):
	health -= damage
	if health < 0:
		WorldMap.enemyKillTile(tile, null)
		get_parent().remove_child(self)
		queue_free()
