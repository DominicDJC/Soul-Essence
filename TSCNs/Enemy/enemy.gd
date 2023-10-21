extends CharacterBody2D

@export var speed = 50
@onready var Sprite = $Enemy
var Player: Node2D
var DroppedItems: Node2D
var WorldMap: TileMap
var target: Node2D
var cooldown = 3.0
var holding = []
var type = "Enemy"
var health = 30
var knockback = false
var angle


func _physics_process(delta):
	getTarget()
	if !knockback:
		if target:
			if position.distance_to(target.position) > 15:
				velocity = Vector2()
				angle = position.angle_to_point(target.position)
				velocity.x = cos(angle)
				velocity.y = sin(angle)
				velocity = velocity * speed
				move_and_slide()
				position = Vector2(round(position.x), round(position.y))
				cooldown = 3.0
			else:
				if cooldown > 0:
					cooldown -= delta
				else:
					WorldMap.enemyKillTile(target.tile, self)
			if velocity.x > 0:
				Sprite.flip_h = false
			if velocity.x < 0:
				Sprite.flip_h = true
	else:
		if cooldown > 0:
			cooldown -= delta
			velocity.x = cos(angle)
			velocity.y = sin(angle)
			velocity = velocity * speed * cooldown * 4
			move_and_slide()
			position = Vector2(round(position.x), round(position.y))
		else:
			knockback = false

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

func hurt(damage := 5):
	health -= damage
	hurtAnimation()
	angle = Player.position.angle_to_point(position)
	knockback = true
	cooldown = 0.5
	if health <= 0:
		kill()

func hurtAnimation():
	for i in 5:
		visible = false
		await get_tree().create_timer(0.05).timeout
		visible = true
		await get_tree().create_timer(0.05).timeout

func kill():
	for i in holding:
		DroppedItems.dropItem(i, position)
	get_parent().remove_child(self)
	queue_free()
