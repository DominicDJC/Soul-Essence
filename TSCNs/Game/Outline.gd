extends Sprite2D

@onready var WorldMap = $"../WorldMap"


func _physics_process(delta):
	position = WorldMap.centerPosition()
	visible = false if WorldMap.posTile() == "Outside" else true
