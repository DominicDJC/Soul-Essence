extends TextureButton

@onready var ItemContainer = $ItemContainer
@onready var Item = $ItemContainer/Item
@onready var Count = $ItemContainer/Count
@onready var Name = $Name
var itemIndex = 0
var itemData = {}
var type = ""
var price = 0
var priceItem = ""

func _physics_process(delta):
	if (type == "Chest" and Inventory.chestOpen) or type == "Inventory":
		itemData = Inventory.getItemDataByIndex(itemIndex)
		if itemData != {}:
			var key = itemData.keys()[0]
			Name.text = key
			var count = itemData[key]
			Item.visible = true
			Item.frame = G.getItemData(key, ["frame"])
			if count > 1:
				Count.text = str(itemData[key])
			else:
				Count.text = ""
		else:
			Item.visible = false
			Count.text = ""
			Name.text = ""
		
		Name.position = get_local_mouse_position() + Vector2(1, -10)
		Name.visible = is_hovered() and !has_focus()
	elif type == "Merchant":
		if itemData != {}:
			var key = itemData.keys()[0]
			var count = itemData[key]
			price = G.getItemData(key, ["price"])
			priceItem = "SoulEssence"
			Name.text = key + "\nPrice: " + str(price) + " " + priceItem
			if Inventory.canAfford({priceItem:price}):
				Name.set("theme_override_colors/font_color",Color(255,255,255))
			else:
				Name.set("theme_override_colors/font_color",Color(160,0,0))
			Item.visible = true
			Item.frame = G.getItemData(key, ["frame"])
			if count > 1:
				Count.text = str(itemData[key])
			else:
				Count.text = ""
		else:
			Item.visible = false
			Count.text = ""
			Name.text = ""
		
		Name.position = get_local_mouse_position() + Vector2(1, -20)
		Name.visible = is_hovered() and !has_focus()

func setItem(newItemIndex):
	itemIndex = newItemIndex

func getItem():
	return Inventory.getItemByIndex(itemIndex)

func getItemIndex():
	return itemIndex

func clearItem():
	$ItemContainer/Item.visible = false

func pressed():
	if type != "Merchant":
		if Inventory.open:
			Inventory.grabItem(itemIndex)
			release_focus()
	else:
		if Inventory.open:
			release_focus()
			if Inventory.canHold(itemData) and Inventory.canAfford({priceItem:price}):
				Inventory.removeItem(priceItem, price)
				Inventory.carryItem(itemData)
