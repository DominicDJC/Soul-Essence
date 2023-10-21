extends Node2D

@onready var WorldMap = get_parent()
const GROW_TIME = 15
var type = "Crop"
var tile: Vector2i
var timer = 0.0
var rng = RandomNumberGenerator.new()
var rngOffset = 0.0
var stage = 1

func _ready():
	rngOffset = rng.randf_range(0.0, 2.0)

func _physics_process(delta):
	if timer < GROW_TIME + rngOffset:
		timer += delta
	else:
		WorldMap.setTile(tile, "SoulStg2")
		stage = 2
