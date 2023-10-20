extends Control

@onready var Merchant = self.get_parent()

func prepareMerchant():
	for i in Merchant.ITEMS_COUNT:
		Inventory.createTile(self, i + Inventory.INVENTORY_SIZE + Inventory.HOTBAR_SIZE, "Merchant")
