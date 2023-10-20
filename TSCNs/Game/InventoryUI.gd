extends GridContainer

@onready var HBox = $".."


func _ready():
	Inventory.inventoryContainer = get_parent()
	prepareInventory()

func prepareInventory():
	for i in Inventory.INVENTORY_SIZE:
		Inventory.createTile(self, i + Inventory.HOTBAR_SIZE)

func _physics_process(delta):
	visible = Inventory.open
	if Inventory.openedMerchant == null:
		if Input.is_action_just_pressed("openInventory"):
			HBox.visible = !Inventory.open
			Inventory.open = !Inventory.open
		if Input.is_action_just_pressed("UIBack") and visible:
			HBox.visible = false
			Inventory.open = false
		if !Inventory.open and Inventory.chestOpen:
			Inventory.closeChest()
