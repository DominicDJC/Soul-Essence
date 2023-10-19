extends Sprite2D

var Player := Node2D
var newFrame = 0
var item = ""
var timer = 0.25

func _ready():
	frame = G.getItemData(item, ["frame"])

func _physics_process(delta):
	#jump(delta)
	var playerPosition = Player.position
	var distanceToPlayer = playerPosition.distance_to(position)
	var speed = 60 / abs(distanceToPlayer)
	var angleToPlayer = position.angle_to_point(playerPosition)
	if distanceToPlayer <= 60:
		position.x += speed * cos(angleToPlayer)
		position.y += speed * sin(angleToPlayer)
	if distanceToPlayer <= 10:
		Player.Inventory.addItem(item)
		queue_free()

func jump(delta):
	if timer > 0.125:
		position.y -= 1
	elif timer > 0:
		position.y += 1
	if timer > 0:
		timer -= delta
	else:
		timer = 0
