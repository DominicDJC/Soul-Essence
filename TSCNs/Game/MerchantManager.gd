extends Node2D

@onready var Merchant = preload("res://TSCNs/Merchant/merchant.tscn")
@onready var Player = $"../Player"
var delayRange = [30, 45]
var delay = 0.0
var rng = RandomNumberGenerator.new()
var useArray = []
var previous = ""
var nightDayOld = "Night"


func _ready():
	rng.randomize()

func _physics_process(delta):
	
	if G.nightDay == "Day":
		if nightDayOld != G.nightDay:
			nightDayOld = G.nightDay
			delay = rng.randi_range(delayRange[0], delayRange[1])
			createMerchant(pickMerchant())
		if delay > 0:
			delay -= delta
		else:
			delay = rng.randi_range(delayRange[0], delayRange[1])
			createMerchant(pickMerchant())
	else:
		nightDayOld = G.nightDay

func pickMerchant():
	var store
	var merchants = ["TrapGuy", "BuilderGuy", "WeaponsGuy", "PlantGuy"]
	if useArray == []:
		merchants.shuffle()
		useArray = merchants
	store = useArray[0]
	useArray.pop_at(0)
	return store

func createMerchant(type):
	var m = Merchant.instantiate()
	m.Player = Player
	m.type = type
	add_child(m)
