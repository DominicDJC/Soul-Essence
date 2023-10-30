extends Control

@onready var FullscreenText = $VBoxContainer/Fullscreen/Label

func _ready():
	$AudioStreamPlayer.play()

func playPressed():
	get_tree().change_scene_to_file("res://TSCNs/Game/game.tscn")

func fullscreenPressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		FullscreenText.text = "Fullscreen"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		FullscreenText.text = "Windowed"
