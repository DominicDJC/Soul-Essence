extends CharacterBody2D

@onready var WorldMap = $"../WorldMap"
@onready var PlayerSprite = $Player
@onready var Hotbar = $"../CanvasLayer/UI/Hotbar"
@onready var Item = $"Item Container/Item"
@onready var Item_Container = $"Item Container"
@export var speed = 150
@export var cameraForward = 40
var direction: Vector2 = Vector2()
var selectedItem = ""
var cooldown = 0.0
var lock = false


func _physics_process(delta):
	read_input()
	selectedItem = Inventory.getItemByIndex(Hotbar.selection)
	
	if Input.is_action_pressed("secondary"):
		if WorldMap.posTile() == "Chest" and !Inventory.chestOpen and !lock:
			Inventory.openChest(WorldMap.getChest())
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
		if Input.is_action_pressed("primary"):
			WorldMap.clearTile()
	if Input.is_action_just_released("primary"):
		WorldMap.lock = false
	if Input.is_action_just_released("secondary"):
		lock = false
	if cooldown > 0:
		cooldown -= delta
	else:
		cooldown = 0

func read_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		direction = Vector2(0, -1)
	if Input.is_action_pressed("down"):
		velocity.y += 1
		direction = Vector2(0, 1)
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		direction = Vector2(1, 0)
	if Input.is_action_pressed("right"):
		velocity.x += 1
		direction = Vector2(1, 0)
	
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

func isPrimaryToTheLeft():
	return (get_local_mouse_position().x < 0)
