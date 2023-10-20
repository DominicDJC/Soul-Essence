extends Node2D

@onready var ChestUI = preload("res://TSCNs/ChestUI/chest_ui.tscn")
@onready var InventoryItemChild = preload("res://Globals/InventoryItemChild/inventory_item_child.tscn")
@onready var InventoryTile = preload("res://TSCNs/InventoryTile/inventory_tile.tscn")
const INVENTORY_SIZE = 9
const HOTBAR_SIZE = 5
var child: Control
var items = []
var heldItem = {}
var heldItemFallbackIndex = null
var open = false
var inventoryContainer: HBoxContainer
var chestOpen = false
var storedChest = null


func _ready():
	prepareInventory([{"Hoe":1}, {"SpikeTrap":99}, {"SpikeTrap":5}, {"StickyTrap":10}, {"PoisonTrap":60}, {"SoulSeed":20}, {"WeakWall":20}, {"AverageWall":20}, {"StrongWall":20}, {"Chest":4}])

func prepareInventory(preset := []):
	items = preset
	for i in (INVENTORY_SIZE + HOTBAR_SIZE - items.size()):
		items.push_back({})

func getHotbar():
	var array = []
	for i in 5:
		array.push_back(items[i])
	return array

func createTile(parent: Control, index, type := "Inventory"):
	var IT = InventoryTile.instantiate()
	IT.setItem(index)
	IT.type = type
	parent.add_child(IT)

func grabItem(index):
	if heldItemFallbackIndex == null and heldItem == {}:
		heldItemFallbackIndex = index
		heldItem = getItemDataByIndex(index)
		clearItemByIndex(index)
	elif heldItemFallbackIndex == index:
		items[index] = heldItem
		heldItem = {}
		heldItemFallbackIndex = null
	else:
		var value = items[index]
		items[index] = heldItem
		items[heldItemFallbackIndex] = value
		heldItem = {}
		heldItemFallbackIndex = null
	child.setData(heldItem)

func getItemByIndex(index):
	if items[index] != {}:
		return items[index].keys()[0]
	else:
		return ""

func getItemDataByIndex(index):
	return items[index]

func addItem(item, count := 1):
	var inventorySize = items.size()
	# Find if existing stack exists
	for i in inventorySize:
		if items[i] != {}:
			if items[i].keys()[0] == item:
				if items[i][item] < 99:
					items[i] = {item : items[i][item] + count}
					return
	for i in inventorySize:
		if items[i] == {}:
			items[i] = {item : count}
			return

func removeItem(item):
	var inventorySize = items.size()
	var smallestIndex = 0
	for i in inventorySize:
		if items[i].keys()[0] == item:
			if items[i][item] < items[smallestIndex][item]:
				smallestIndex = i
	removeItemByIndex(item, smallestIndex)

func removeItemByIndex(item, index, count := 1):
	var key = items[index].keys()[0]
	if key == item:
		if items[index][key] > 1:
			items[index] = {item:items[index][key] - count}
		else:
			items[index] = {}

func clearItemByIndex(index):
	items[index] = {}

func openChest(Chest: Node2D):
	storedChest = Chest
	chestOpen = true
	for i in Chest.items:
		items.push_back(i)
	var CUI = ChestUI.instantiate()
	CUI.chestNode = Chest
	inventoryContainer.add_child(CUI)
	open = true
	inventoryContainer.visible = true

func closeChest():
	for i in 9:
		storedChest.items[i] = items[i + HOTBAR_SIZE + INVENTORY_SIZE]
	storedChest = null
	inventoryContainer.get_child(1).queue_free()
	chestOpen = false
	var array = []
	for i in INVENTORY_SIZE + HOTBAR_SIZE:
		array.push_back(items[i])
	items = array
