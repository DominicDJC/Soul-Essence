extends Camera2D

@export var Target: Node2D
@export var speed = 5
@export var defaultZoom = Vector2(2, 2)
@export var zoomScale = Vector2(.5, .5)
@onready var Center = $"../Center"
@onready var Player = $"../Player"

func _ready():
	G.MainCam = self
	G.Center = Center
	zoom = defaultZoom
	position = Target.position

func _physics_process(delta):
	position = lerp(position, Target.position, speed * delta)

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		zoom += zoomScale
	if event.is_action_pressed("zoom_out"):
		zoom -= zoomScale
	if event.is_action_pressed("zoom_reset"):
		zoom = defaultZoom
	if event.is_action_pressed("debugcam"):
		if Target == Player:
			Target = Center
		elif Target == Center:
			Target = Player
