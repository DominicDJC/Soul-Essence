extends Sprite2D

@onready var Player = $"../.."
@onready var MeleeRange = $"../../MeleeRange"
@onready var RangedRange = $"../../RangedRange"
var targetAngle = 0
var speed = 0
var action = ""
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
			if action != "HoeUse":
				action = "HoeUse"
				frame = 0
				visible = true
				await swing(5, 120)
				visible = false
				action = ""

func primary(selectedItem, interactingItem):
	match selectedItem:
		"Hoe":
			if action != "HoeAttack":
				action = "HoeAttack"
				frame = 0
				visible = true
				for i in MeleeRange.getEnemies():
					i.hurt(Player, 3)
				await swing(15, 160, -120)
				visible = false
				action = ""
		"Sword":
			if action != "SwordAttack":
				action = "SwordAttack"
				frame = 10
				visible = true
				for i in MeleeRange.getEnemies():
					i.hurt(Player, 7)
				await swing(15, 160, -120)
				visible = false
				action = ""
		"Gun":
			if action != "ShootGun":
				action = "ShootGun"
				frame = 11
				visible = true
				targetAngle = get_parent().position.angle_to_point(get_local_mouse_position())
				rotation = get_parent().position.angle_to_point(get_local_mouse_position())
				for i in RangedRange.getEnemies():
					i.hurt(Player, 5)
				await get_tree().create_timer(.5).timeout
				visible = false
				rotation_degrees = 0
				action = ""

func swing(newSpeed, newTargetAngle, start := 0):
	rotation_degrees = start
	speed = newSpeed
	targetAngle = newTargetAngle
	await rotation_complete
	speed = 0
	targetAngle = 0
	rotation_degrees = 0
