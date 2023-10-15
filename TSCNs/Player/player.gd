extends CharacterBody2D

@onready var PlayerSprite = $PlaceHolderPlayer
@export var speed = 150
@export var cameraForward = 40
var direction: Vector2 = Vector2()


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
