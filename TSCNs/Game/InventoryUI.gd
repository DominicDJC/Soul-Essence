extends GridContainer


func _ready():
	Inventory.inventoryContainer = get_parent()
	prepareInventory()

func prepareInventory():
	for i in Inventory.INVENTORY_SIZE:
		Inventory.createTile(self, i + Inventory.HOTBAR_SIZE)

func _physics_process(delta):
	visible = Inventory.open
	if Input.is_action_just_pressed("openInventory"):
		Inventory.open = !Inventory.open
	if Input.is_action_just_pressed("UIBack") and visible:
		Inventory.open = false
	if !Inventory.open and Inventory.chestOpen:
		Inventory.closeChest()
