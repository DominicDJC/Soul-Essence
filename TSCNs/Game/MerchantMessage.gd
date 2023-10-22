extends Node2D

@onready var Lbl = $Label
var target


func _physics_process(delta):
	if visible and target != null:
		position = target.position

func displayMessage(message: String, time: float, object):
	target = object
	Lbl.text = message
	visible = true
	await get_tree().create_timer(time).timeout
	visible = false
