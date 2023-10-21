extends CharacterBody2D


@onready var Sprite = $Enemy
@onready var HealthBar = $HealthBar
const MAX_HEALTH = 30
const NEEDED_SOUL_ESSENCE = 5
var Portal: Node2D
var Player: Node2D
var DroppedItems: Node2D
var WorldMap: TileMap
var virtualPosition = Vector2(0, 0)
var target: Node2D
var speed: int = 50
var cooldown = 3.0
var holding = []
var type = "Enemy"
var health = MAX_HEALTH
var knockback = false
var knockbackSpeed = 0
var angle
var angry = 0.0
var surroundings = []
var surroundingsCountdown = 0.0


func _physics_process(delta):
	print(speed)
	attackSurroundings(delta)
	if angry > 0:
		angry -= delta
	elif essenceCheck():
		target = Portal
	elif G.nightDay == "Day":
		angry = 0.0
		target = closest(get_parent().getLeftRight())
	else:
		getTarget()
	if !knockback:
		if target:
			if position.distance_to(target.position) > (30 if angry > 0 else 15):
				velocity = Vector2()
				angle = position.angle_to_point(target.position)
				velocity.x = cos(angle)
				velocity.y = sin(angle)
				position += velocity * delta * speed
				#position = Vector2(round(position.x), round(position.y))
				cooldown = 0.0 if angry > 0 else 3.0
			else:
				if G.nightDay == "Day":
					get_parent().remove_child(self)
					queue_free()
				if cooldown > 0:
					cooldown -= delta
				else:
					if angry > 0:
						target.hurt(self)
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
			velocity = velocity * knockbackSpeed * cooldown * 8
			move_and_slide()
			position = Vector2(round(position.x), round(position.y))
		else:
			knockback = false

func closest(array):
	var close
	for i in array:
		if close == null:
			close = i
		elif close.position.distance_to(position) > i.position.distance_to(position):
			close = i
	return close

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
		angry = 1.0
		target = Player

func hurt(source, damage := 5, newKnockbackSpeed := speed, newAngry := 10.0):
	if health > 0:
		health -= damage
		HealthBar.update(health, MAX_HEALTH)
		hurtAnimation(health <= 0)
		if source:
			angle = source.position.angle_to_point(position)
			knockback = true
			cooldown = 0.5
			angry = newAngry
			target = source
			knockbackSpeed = newKnockbackSpeed

func hurtAnimation(kill := false):
	for i in 5:
		visible = false
		await get_tree().create_timer(0.05).timeout
		visible = true
		await get_tree().create_timer(0.05).timeout
	if kill:
		kill()

func kill():
	for i in holding:
		DroppedItems.dropItem(i, position)
	get_parent().remove_child(self)
	queue_free()

func essenceCheck():
	var count = 0
	for i in holding:
		if i == "SoulEssence":
			count += 1
	return count >= NEEDED_SOUL_ESSENCE

func areaEntered(area):
	if area.get_parent().name == "Portal" and essenceCheck():
		get_parent().remove_child(self)
		queue_free()
		print("bye bye")


func bodyEntered(body):
	if ("type" in body.get_parent()) and body.get_parent().type == "Wall":
		surroundings.push_back(body.get_parent())

func bodyExited(body):
	if surroundings.has(body.get_parent()):
		surroundings.erase(body.get_parent())

func attackSurroundings(delta):
	if surroundings != []:
		if surroundingsCountdown > 0:
			surroundingsCountdown -= delta
		else:
			surroundingsCountdown = 3
			for i in surroundings:
				i.hurt(self)
