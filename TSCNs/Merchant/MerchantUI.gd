extends HBoxContainer

@onready var Merchant = self.get_parent()

func _physics_process(delta):
	if (Input.is_action_just_pressed("openInventory") or Input.is_action_just_pressed("UIBack"))and visible:
		Inventory.closeMerchant()

func prepareMerchant(data: Array):
	for i in Merchant.ITEMS_COUNT:
		Inventory.createTile(self, i + Inventory.INVENTORY_SIZE + Inventory.HOTBAR_SIZE, "Merchant", {data[i]:1 if data[i] != "SoulSeed" else 2})
