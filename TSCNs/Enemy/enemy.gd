extends CharacterBody2D

@export var speed = 50
var WorldMap: TileMap
var target: Node2D
var cooldown = 3.0
var holding = []

func _physics_process(delta):
	getTarget()
	if target:
		if position.distance_to(target.position) > 15:
			var angleToTarget = position.angle_to_point(target.position)
			velocity.x = cos(angleToTarget)
			velocity.y = sin(angleToTarget)
			velocity = velocity.normalized() * speed
			move_and_slide()
			position = Vector2(round(position.x), round(position.y))
			cooldown = 3.0
		else:
			if cooldown > 0:
				cooldown -= delta
			else:
				WorldMap.enemyKillTile(target.tile, self)

func getTarget():
	if WorldMap.getCrops() != []:
		for i in WorldMap.getCrops():
			if i.stage == 2:
				if target == null:
					target = i
				elif position.distance_to(i.position) < position.distance_to(target.position):
					target = i
		if target == null:
			for i in WorldMap.getCrops():
				if target == null:
					target = i
				elif position.distance_to(i.position) < position.distance_to(target.position):
					target = i
	else:
		target = null
