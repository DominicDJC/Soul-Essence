extends Control


func _ready():
	G.GameOver = self

func mainMenuPress():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TSCNs/MainMenu/main_menu.tscn")
