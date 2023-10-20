extends Node2D

@onready var WorldMap = get_parent()
var type = "Crop"
var tile: Vector2i
var timer = 0.0


func _physics_process(delta):
	if timer < 60:
		timer += delta
	else:
		WorldMap.setTile(tile, "SoulStg2")
