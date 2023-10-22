extends Control

@onready var Outside = $OutsideVBox
@onready var AreYouSure = $AreYouSure
@onready var FullscreenText = $OutsideVBox/Fullscreen/Label
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
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TSCNs/MainMenu/main_menu.tscn")

func secondBackPressed():
	Outside.visible = true
	AreYouSure.visible = false



func fullscreenPressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		FullscreenText.text = "Fullscreen"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		FullscreenText.text = "Windowed"
