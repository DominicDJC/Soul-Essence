extends CharacterBody2D

@onready var PlayerSprite = $PlaceHolderPlayer
@onready var PlacePoint = $PlacePoint
@onready var Hotbar = $"../CanvasLayer/UI/Hotbar"
@export var speed = 150
@export var cameraForward = 40
var direction: Vector2 = Vector2()
var inventory = [{"Crop1":99}, {"Crop2":60}, {"Crop3":40}, {"Crop4":20}, {"Hoe":1}]
var hotbar = []
var selectedItem = ""


func _ready():
	for i in 5:
		var key = inventory[i].keys()[0]
		hotbar.push_back(key)
		Hotbar.get_child(i).text = key

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
	
	if velocity.x > 0:
		PlayerSprite.flip_h = false
	if velocity.x < 0:
		PlayerSprite.flip_h = true
	
	velocity = velocity.normalized() * speed
	move_and_slide()
	position = Vector2(round(position.x), round(position.y))

func _physics_process(delta):
	read_input()
