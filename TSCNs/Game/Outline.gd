extends Sprite2D

@onready var Player = $"../Player"
@onready var WorldMap = $"../WorldMap"


func _physics_process(delta):
	position = WorldMap.centerPosition()
	visible = restraintsGood() and !["Outside", "Path"].has(WorldMap.posTile()) and !Inventory.open

func restraintsGood():
	var playerCoords = WorldMap.local_to_map(Player.position)
	var tile = WorldMap.local_to_map(position)
	if abs(tile.x - playerCoords.x) >= 6:
		return false
	if abs(tile.y - playerCoords.y) >= 6:
		return false
	return true
