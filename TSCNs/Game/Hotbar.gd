extends HBoxContainer

@export var Player: Node2D
var selection = 0 : set = setSelection


func _physics_process(delta):
	if Input.is_action_just_pressed("hotbar1"):
		selection = 0
	if Input.is_action_just_pressed("hotbar2"):
		selection = 1
	if Input.is_action_just_pressed("hotbar3"):
		selection = 2
	if Input.is_action_just_pressed("hotbar4"):
		selection = 3
	if Input.is_action_just_pressed("hotbar5"):
		selection = 4

func setSelection(value):
	selection = value
	get_child(selection).grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("hotbarNext"):
		if selection == 4:
			selection = 0
		else:
			selection += 1
	if event.is_action_pressed("hotbarPrevious"):
		if selection == 0:
			selection = 4
		else:
			selection -= 1

func onePressed():
	selection = 0

func twoPressed():
	selection = 1

func threePressed():
	selection = 2

func fourPressed():
	selection = 3

func fivePressed():
	selection = 4
