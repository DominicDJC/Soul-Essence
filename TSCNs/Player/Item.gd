extends Sprite2D

@onready var MeleeRange = $"../../MeleeRange"
var targetAngle = 0
var speed = 0
signal rotation_complete

func _physics_process(delta):
	if rotation_degrees < targetAngle:
		rotation_degrees += speed
	else:
		rotation_degrees = targetAngle
		emit_signal("rotation_complete")

func secondary(selectedItem):
	match selectedItem:
		"Hoe":
			frame = 0
			visible = true
			await swing(5, 120)
			visible = false

func primary(selectedItem, interactingItem):
	match selectedItem:
		"Hoe":
			frame = 0
			if G.getItemData(interactingItem, ["type"]) == "crop":
				visible = true
				await swing(5, 120)
				visible = false
		"Sword":
			frame = 10
			visible = true
			for i in MeleeRange.getEnemies():
				i.hurt()
			await swing(15, 160, -120)
			visible = false

func swing(newSpeed, newTargetAngle, start := 0):
	rotation_degrees = start
	speed = newSpeed
	targetAngle = newTargetAngle
	await rotation_complete
	speed = 0
	targetAngle = 0
	rotation_degrees = 0
