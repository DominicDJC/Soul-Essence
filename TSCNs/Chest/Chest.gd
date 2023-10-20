extends Node2D

const CHEST_SIZE = 9
var tile: Vector2i
var items = []

func _ready():
	prepareItems()

func prepareItems():
	for i in CHEST_SIZE - items.size():
		items.push_back({})

func getItemDataByIndex(index):
	return items[index]

func isEmpty() -> bool:
	for i in items:
		if i != {}:
			return false
	return true
