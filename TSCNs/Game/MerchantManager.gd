extends Node2D

@onready var Merchant = preload("res://TSCNs/Merchant/merchant.tscn")
@onready var Player = $"../Player"


func _ready():
	createMerchant(Vector2(200, 200), "TrapGuy")

func createMerchant(pos, type):
	var m = Merchant.instantiate()
	m.Player = Player
	m.type = type
	m.position = pos
	add_child(m)
