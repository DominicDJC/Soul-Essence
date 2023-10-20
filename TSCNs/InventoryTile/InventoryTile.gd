extends TextureButton

@onready var ItemContainer = $ItemContainer
@onready var Item = $ItemContainer/Item
@onready var Count = $ItemContainer/Count
@onready var Name = $Name
var itemIndex = 0
var itemData = {}

func _physics_process(delta):
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

func setItem(newItemIndex):
	itemIndex = newItemIndex

func getItem():
	return Inventory.getItemByIndex(itemIndex)

func getItemIndex():
	return itemIndex

func clearItem():
	$ItemContainer/Item.visible = false

func pressed():
	if Inventory.open:
		Inventory.grabItem(itemIndex)
	release_focus()
