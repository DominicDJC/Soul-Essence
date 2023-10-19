extends Node2D

const MAX_INVENTORY_SIZE = 9
const HOTBAR_SIZE = 5
var items = []


func _ready():
	prepareInventory([{"SoulSeed":20}, {"SpikeTrap":10}, {"StickyTrap":60}, {"WeakWall":20}, {"Hoe":1}])

func prepareInventory(preset := []):
	items = preset
	for i in (MAX_INVENTORY_SIZE + HOTBAR_SIZE - items.size()):
		items.push_back({})

func getHotbar():
	var array = []
	for i in 5:
		array.push_back(items[i])
	return array

func getItemByIndex(index):
	if items[index] != {}:
		return items[index].keys()[0]
	else:
		return ""
	

func addItem(item):
	var inventorySize = items.size()
	for i in inventorySize:
		if items[i].keys()[0] == item:
			if items[i][item] < 99:
				items[i] = {item : items[i][item] + 1}
				return
	if inventorySize < MAX_INVENTORY_SIZE:
		for i in inventorySize:
			if items[i] == {}:
				items[i] = {item:1}
				return

func removeItem(item):
	var inventorySize = items.size()
	var smallestIndex = 0
	for i in inventorySize:
		if items[i].keys()[0] == item:
			if items[i][item] < items[smallestIndex][item]:
				smallestIndex = i
	removeItemByIndex(item, smallestIndex)

func removeItemByIndex(item, index):
	var key = items[index].keys()[0]
	if key == item:
		if items[index][key] > 1:
			items[index] = {item:items[index][key] - 1}
		else:
			items[index] = {}
