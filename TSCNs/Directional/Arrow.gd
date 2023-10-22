extends Sprite2D


func update(newRotation):
	rotation_degrees = newRotation
	match newRotation:
		0:
			position = Vector2(-1, 2)
		90:
			position = Vector2(0, 2)
		180:
			position = Vector2(0, 3)
		270:
			position = Vector2(-1, 3)
