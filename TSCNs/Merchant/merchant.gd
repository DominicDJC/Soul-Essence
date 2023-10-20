extends Node2D

const ITEMS_COUNT = 3
var type = ""
var items = []
var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()
	prepareItems()

func prepareItems():
	items = []
	var itemPool = itemPool(type)
	for i in ITEMS_COUNT:
		var randomInt = rng.randi_range(0, itemPool.size() - 1)
		items[i] = itemPool[randomInt]
		itemPool.pop_at(randomInt)

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
