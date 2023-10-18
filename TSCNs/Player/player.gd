extends CharacterBody2D

@onready var WorldMap = $"../WorldMap"
@onready var PlayerSprite = $Player
@onready var Hotbar = $"../CanvasLayer/UI/Hotbar"
@onready var Item = $"Item Container/Item"
@onready var Item_Container = $"Item Container"
@export var speed = 150
@export var cameraForward = 40
var direction: Vector2 = Vector2()
var inventory = [{"Crop1":99}, {"Crop2":60}, {"Crop3":40}, {"Crop4":20}, {"Hoe":1}]
var hotbar = []
var selectedItem = ""
var cooldown = 0.0


func _ready():
	for i in 5:
		var key = inventory[i].keys()[0]
		hotbar.push_back(key)
		Hotbar.get_child(i).text = key

func _physics_process(delta):
	read_input()
	selectedItem = hotbar[Hotbar.selection]
	
	if Input.is_action_pressed("primary"):
		Item.primary(selectedItem)
	elif Input.is_action_just_pressed("secondary"):
		Item.secondary(selectedItem, WorldMap.mouseOverTile())
	
	if cooldown == 0:
		if Input.is_action_pressed("primary"):
			WorldMap.placeTile(selectedItem)
			cooldown = .1
		if Input.is_action_pressed("secondary"):
			WorldMap.clearTile()
			cooldown = .1
	if Input.is_action_just_released("secondary"):
		WorldMap.lock = false
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
	
	if Input.is_action_pressed("primary"):
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
