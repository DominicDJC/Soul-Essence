extends Node2D

@onready var Health = $Health

func update(current, max):
	if current == 0:
		Health.visible = false
	else:
		Health.scale.x = (float(current) / float(max))
		Health.visible = true
