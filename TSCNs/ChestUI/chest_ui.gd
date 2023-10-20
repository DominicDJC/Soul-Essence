extends GridContainer

var chestNode: Node2D

func _ready():
	prepareChest()

func prepareChest():
	for i in chestNode.CHEST_SIZE:
		Inventory.createTile(self, i + Inventory.INVENTORY_SIZE + Inventory.HOTBAR_SIZE, "Chest")

func _physics_process(delta):
	visible = Inventory.open
