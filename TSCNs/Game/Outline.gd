extends Sprite2D

@onready var WorldMap = $"../WorldMap"


func _physics_process(delta):
	position = WorldMap.centerPosition()
	visible = false if ["Outside"].has(WorldMap.posTile()) else (true if !Inventory.open else false)
