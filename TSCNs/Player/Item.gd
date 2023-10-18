extends Sprite2D

var targetAngle = 0
var speed = 0
signal rotation_complete

func _physics_process(delta):
	if rotation_degrees < targetAngle:
		rotation_degrees += speed
	else:
		rotation_degrees = targetAngle
		emit_signal("rotation_complete")

func primary(selectedItem):
	match selectedItem:
		"Hoe":
			visible = true
			await swing(5, 120)
			visible = false

func secondary(selectedItem, interactingItem):
	match selectedItem:
		"Hoe":
			if G.getItemData(interactingItem, ["type"]) == "crop":
				visible = true
				await swing(5, 120)
				visible = false

func swing(newSpeed, newTargetAngle):
	speed = newSpeed
	targetAngle = newTargetAngle
	await rotation_complete
	speed = 0
	targetAngle = 0
	rotation_degrees = 0
