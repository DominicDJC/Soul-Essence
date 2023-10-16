extends HBoxContainer

var values = ["Crop16", "Hoe", "Empty", "Empty", "Empty"]
var selection = 0 : set = setSelection


func setSelection(value):
	get_child(value).grab_focus()
	selection = value

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
