extends Node2D

@onready var MerchantUI = $MerchantUI
const ITEMS_COUNT = 3
var Player: Node2D
var type = ""
var items = []
var rng = RandomNumberGenerator.new()
var mouseIn = false


func _ready():
	rng.randomize()
	prepareItems()
	MerchantUI.visible = false

func _physics_process(delta):
	if mouseIn:
		if !Player.merchants.has(self):
			Player.merchants.push_back(self)
	else:
		if Player.merchants.has(self):
			Player.merchants.erase(self)

func prepareItems():
	items = []
	var pool = itemPool(type)
	for i in ITEMS_COUNT:
		var randomInt = rng.randi_range(0, pool.size() - 1)
		items.push_back(pool[randomInt])
		pool.pop_at(randomInt)
	MerchantUI.prepareMerchant(items)

func itemPool(type):
	match type:
		"TrapGuy":
			return ["SpikeTrap", "StickyTrap", "PoisonTrap"]
		"BuilderGuy":
			return ["WeakWall", "AverageWall", "StrongWall", "Chest"]
		"WeaponsGuy":
			return []
		"PlantGuy":
			return ["SoulSeed", "SoulSeed", "SoulSeed"]

func mouseEntered():
	mouseIn = true

func mouseExited():
	mouseIn = false
