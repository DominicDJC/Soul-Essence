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
var inventoryContainer: GridContainer
var chestOpen = false
var storedChest = null
var openedMerchant = null


func _ready():
	prepareInventory([{"Hoe":1}, {"SpikeTrap":98}, {"SpikeTrap":5}, {"StickyTrap":10}, {"PoisonTrap":90}, {"SoulSeed":20}, {"WeakWall":20}, {"AverageWall":20}, {"StrongWall":20}, {"Chest":4}, {"SoulEssence":99}, {"SoulEssence":99}, {"SoulEssence":99}])

func prepareInventory(preset := []):
	items = preset
	for i in (INVENTORY_SIZE + HOTBAR_SIZE - items.size()):
		items.push_back({})

func getHotbar():
	var array = []
	for i in 5:
		array.push_back(items[i])
	return array

func createTile(parent: Control, index, type := "Inventory", data := {}):
	var IT = InventoryTile.instantiate()
	IT.setItem(index)
	IT.type = type
	if type == "Merchant":
		IT.itemData = data
	parent.add_child(IT)

func grabItem(index):
	var itemData = getItemDataByIndex(index)
	if heldItemFallbackIndex == null and heldItem == {}:
		if itemData != {}:
			heldItemFallbackIndex = index
			heldItem = itemData
			clearItemByIndex(index)
	elif itemData == {}:
		items[index] = heldItem
		heldItem = {}
		heldItemFallbackIndex = null
	elif itemData != {} and itemData.keys()[0] == heldItem.keys()[0]:
		var itemKey = itemData.keys()[0]
		var itemCount = itemData[itemKey]
		if itemCount + heldItem[itemKey] < 100:
			items[index] = {itemKey:itemCount + heldItem[itemKey]}
			heldItem = {}
			heldItemFallbackIndex = null
		else:
			items[index] = {itemKey:99}
			heldItem = {itemKey:itemCount + heldItem[itemKey] - 99}
	else:
		var value = items[index]
		items[index] = heldItem
		items[heldItemFallbackIndex] = value
		heldItem = {}
		heldItemFallbackIndex = null
	child.setData(heldItem)

func carryItem(itemData):
	var itemKey = itemData.keys()[0]
	var itemCount = itemData[itemKey]
	if heldItemFallbackIndex == null and heldItem == {}:
		heldItemFallbackIndex = nextEmpty()
		heldItem = itemData
	elif heldItem != {} and heldItem.keys()[0] == itemKey and (heldItem[itemKey] + itemCount < 100):
		heldItem = {itemKey:itemCount + heldItem[itemKey]}
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

func removeItem(item, count := 1):
	var inventorySize = items.size()
	var smallestIndex = -1
	for i in inventorySize:
		if items[i] != {} and items[i].keys()[0] == item:
			if smallestIndex == -1:
				smallestIndex = i
			elif items[i][item] < items[smallestIndex][item]:
				smallestIndex = i
	removeItemByIndex(item, smallestIndex, count)

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
	inventoryContainer.columns = 2
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

func openMerchant(Merchant: Node2D):
	inventoryContainer.columns = 1
	inventoryContainer.visible = true
	open = true
	var UI = Merchant.MerchantUI
	Merchant.remove_child(UI)
	inventoryContainer.add_child(UI)
	UI.visible = true
	openedMerchant = Merchant

func closeMerchant():
	open = false
	var UI = inventoryContainer.get_child(1)
	inventoryContainer.remove_child(UI)
	openedMerchant.add_child(UI)
	UI.visible = false
	openedMerchant = null

func canAfford(itemData := {}):
	if itemData != {}:
		var key = itemData.keys()[0]
		var count = itemData[key]
		for i in items:
			if i != {}:
				var iKey = i.keys()[0]
				var iCount = i[iKey]
				if key == iKey and iCount >= count:
					return true
	return false

func hasEmptySpace():
	for i in items:
		if i == {}:
			return true
	return false

func canHold(itemData):
	print(itemData)
	if itemData != {}:
		var key = itemData.keys()[0]
		var count = itemData[key]
		for i in items:
			print(i)
			if i == {}:
				print("i == {}")
				return true
			else:
				var iKey = i.keys()[0]
				var iCount = i[iKey]
				if heldItem != {}:
					print("heldItem != {}")
					var heldKey = heldItem.keys()[0]
					var heldCount = heldItem[heldKey]
					print(heldKey)
					print(iKey)
					print(key)
					if (iCount + count + heldCount < 100) and heldKey == key and iKey == key:
						print("iCount + count + heldCount < 100")
						return true
				elif (iCount + count < 100) and iKey == key:
					print("iCount + count < 100")
					return true
	return false

func nextEmpty():
	for i in items.size():
		if items[i] == {}:
			return i
