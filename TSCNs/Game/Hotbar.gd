extends HBoxContainer

@onready var Player = $"../../../Player"
@onready var InventoryUI = $"../CenterContainer/InventoryUI"
var selection = 0 : set = setSelection
var openOld = Inventory.open


func _ready():
	prepareHotbar()

func _physics_process(delta):
	if openOld != Inventory.open:
		openOld = Inventory.open
		if !openOld:
			selection = selection
		else:
			get_child(selection).release_focus()
	if Input.is_action_just_pressed("hotbar1"):
		selection = 0
	if Input.is_action_just_pressed("hotbar2"):
		selection = 1
	if Input.is_action_just_pressed("hotbar3"):
		selection = 2
	if Input.is_action_just_pressed("hotbar4"):
		selection = 3
	if Input.is_action_just_pressed("hotbar5"):
		selection = 4
	if !openOld:
		for i in get_child_count():
			if get_child(i).button_pressed:
				selection = i

func _unhandled_input(event):
	if event.is_action_pressed("hotbarNext"):
		if selection == 4:
			selection = 0
		else:
			selection += 1
	if event.is_action_pressed("hotbarPrevious"):
		if selection == 0:
			selection = 4
		else:
			selection -= 1

func setSelection(value):
	selection = value
	get_child(selection).grab_focus()

func prepareHotbar():
	for i in Inventory.HOTBAR_SIZE:
		Inventory.createTile(self, i)

func updateHotbar(index):
	get_child(index).setItem(index)
