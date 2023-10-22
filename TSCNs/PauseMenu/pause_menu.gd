extends Control

@onready var Outside = $OutsideVBox
@onready var AreYouSure = $AreYouSure
var paused = false : set = setPause

func _unhandled_key_input(event):
	if event.is_action_pressed("UIBack") and !Inventory.open:
		paused = !paused

func setPause(value):
	get_tree().paused = value
	if value:
		visible = true
		Outside.visible = true
		AreYouSure.visible = false
	else:
		visible = false
	paused = value


func resumePressed():
	paused = false

func quitPressed():
	Outside.visible = false
	AreYouSure.visible = true



func secondQuitPressed():
	pass

func secondBackPressed():
	Outside.visible = true
	AreYouSure.visible = false

