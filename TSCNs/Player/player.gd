extends CharacterBody2D

@onready var WorldMap = $"../WorldMap"
@onready var PlayerSprite = $Player
@onready var Hotbar = $"../CanvasLayer/UI/Hotbar"
@onready var Item = $"Item Container/Item"
@onready var Item_Container = $"Item Container"
@onready var HealthBar = $"../CanvasLayer/UI/HBoxContainer/PlayerHealthContainer/Playerhealth"
@export var speed = 150
@export var cameraForward = 40
const MAX_HEATLH = 120
var merchants = []
var selectedItem = ""
var cooldown = 0.0
var lock = false
var health = MAX_HEATLH
var moveCooldown = 0.0
var angle
var knockback = false
var hurtCooldown = 0.0
var healCooldown = 0.0


func _physics_process(delta):
	if health < MAX_HEATLH:
		if healCooldown > 0:
			healCooldown -= delta
		else:
			healCooldown = 10.0
			health += 1
	if health > MAX_HEATLH:
		health = MAX_HEATLH
		
	
	if hurtCooldown > 0:
		hurtCooldown -= delta
	
	HealthBar.update(health, MAX_HEATLH)
	read_input(delta)
	selectedItem = Inventory.getItemByIndex(Hotbar.selection)
	
	if Input.is_action_pressed("secondary"):
		if WorldMap.posTile() == "Chest" and !Inventory.chestOpen and !lock:
			Inventory.openChest(WorldMap.getChest())
		elif merchants != [] and !Inventory.open:
			Inventory.openMerchant(merchants[0])
		else:
			Item.secondary(selectedItem)
	elif Input.is_action_just_pressed("primary"):
		Item.primary(selectedItem, WorldMap.posTile())
	
	if cooldown == 0 and !Inventory.open:
		if Input.is_action_pressed("secondary"):
			if WorldMap.placeTile(selectedItem) and !G.getItemData(selectedItem, ["unlimited"]):
				Inventory.removeItemByIndex(selectedItem, Hotbar.selection)
				Hotbar.updateHotbar(Hotbar.selection)
				lock = true
		if Input.is_action_pressed("primary") and !["Hoe", "Sword", "Slingshot"].has(selectedItem):
			WorldMap.clearTile()
	if Input.is_action_just_released("primary"):
		WorldMap.lock = false
	if Input.is_action_just_released("secondary"):
		lock = false
	if cooldown > 0:
		cooldown -= delta
	else:
		cooldown = 0
	
	if Input.is_action_just_pressed("secondary") and WorldMap.posTile() == "Directional":
		WorldMap.getProjectile("Directional").doRotate()

func read_input(delta):
	if !knockback:
		velocity = Vector2()
		
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
		
		if Item.action == "":
			if Input.is_action_pressed("primary") or Input.is_action_pressed("secondary"):
				if isPrimaryToTheLeft():
					PlayerSprite.flip_h = true
					Item_Container.scale.x = -1
				else:
					PlayerSprite.flip_h = false
					Item_Container.scale.x = 1
			else:
				if velocity.x > 0:
					PlayerSprite.flip_h = false
					Item_Container.scale.x = 1
				if velocity.x < 0:
					PlayerSprite.flip_h = true
					Item_Container.scale.x = -1
		
		velocity = velocity.normalized() * speed
		move_and_slide()
		position = Vector2(round(position.x), round(position.y))
	else:
		if moveCooldown > 0:
			moveCooldown -= delta
			velocity.x = cos(angle)
			velocity.y = sin(angle)
			velocity = velocity * speed * moveCooldown * 4
			move_and_slide()
			position = Vector2(round(position.x), round(position.y))
		else:
			knockback = false

func isPrimaryToTheLeft():
	return (get_local_mouse_position().x < 0)

func hurt(source, damage := 5):
	if hurtCooldown <= 0:
		print("Hurt by:")
		print(source)
		print("Damage:")
		print(damage)
		print("Current health:")
		print(health)
		health -= damage
		print("Health following calculation:")
		print(health)
		hurtAnimation()
		angle = source.position.angle_to_point(position)
		knockback = true
		moveCooldown = 0.5
		hurtCooldown = 1.0
		if health <= 0:
			kill()

func hurtAnimation():
	for i in 5:
		visible = false
		await get_tree().create_timer(0.05).timeout
		visible = true
		await get_tree().create_timer(0.05).timeout

func kill():
	G.gameover.emit()

