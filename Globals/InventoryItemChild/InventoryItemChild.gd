extends Control


func _ready():
	setData({})
	Inventory.child = self

func _physics_process(delta):
	position = get_global_mouse_position()

func setCount(count):
	if count > 1:
		$Count.text = count
	else:
		$Count.text = ""

func setItem(item):
	if item == "":
		visible = false
	else:
		$Item.frame = G.getItemData(item, ["frame"])
		visible = true

func setData(data):
	if data == {}:
		visible = false
	else:
		var item = data.keys()[0]
		var count = data[item]
		if count > 1:
			$Count.text = str(count)
		else:
			$Count.text = ""
		$Item.frame = G.getItemData(item, ["frame"])
		visible = true
