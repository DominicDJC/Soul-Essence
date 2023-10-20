extends GridContainer


func _ready():
	prepareInventory()

func prepareInventory():
	for i in Inventory.INVENTORY_SIZE:
		Inventory.createTile(self, i + Inventory.HOTBAR_SIZE)

func _physics_process(delta):
	Inventory.open = visible
	if Input.is_action_just_pressed("openInventory"):
		visible = !visible
	if Input.is_action_just_pressed("UIBack") and visible:
		visible = false
