extends TileMap

@export var permaTiles: PackedStringArray
@export var Player: Node2D
@export var Hotbar: Control
var breakLayer = 0
var lock = false
var cooldown = 0.0

func _physics_process(delta):
	if cooldown == 0:
		if Input.is_action_pressed("place"):
				placeTile()
		if Input.is_action_pressed("remove"):
				clearTile()
	if Input.is_action_just_released("remove"):
		lock = false
	if cooldown > 0:
		cooldown -= delta
	else:
		cooldown = 0

func getTile(value):
	var dict = {
		"Land": Vector2i(0, 0),
		"Outside": Vector2i(1, 0),
		"Soil": Vector2i(2, 0),
		"Crop1": Vector2i(3, 0),
		"Crop2": Vector2i(4, 0),
		"Crop3": Vector2i(5, 0),
		"Crop4": Vector2i(6, 0)
	}
	if typeof(value) == TYPE_VECTOR2I:
		for key in dict.keys():
			if dict[key] == get_cell_atlas_coords(0, value):
				return key
		return "unknown"
	else:
		if dict.has(value):
			return dict[value]
		return Vector2i(0, 0)

func placeTile(localPosition: = get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	var item = Hotbar.values[Hotbar.selection]
	var tileType = getTile(tile)
	if restraintsGood(tile):
		if item == "Hoe" and tileType == "Land":
			set_cell(0, tile, 2, getTile("Soil"))
		elif G.itemData.has(item) and G.itemData[item].has("Tile"):
			var itemTile = G.itemData[item]["Tile"]
			match tileType:
				"Soil":
					match itemTile:
						"Crop1", "Crop2", "Crop3", "Crop4":
							set_cell(0, tile, 2, getTile(itemTile))
	cooldown = .05

func clearTile(localPosition: = get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	var tileType = getTile(tile)
	if restraintsGood(tile):
		match tileType:
			"Crop1", "Crop2", "Crop3", "Crop4":
				if breakLayer == 1:
					set_cell(0, tile, 2, getTile("Soil"))
				if lock == false:
					breakLayer = 1
				lock = true
			"Soil":
				if breakLayer == 0:
					set_cell(0, tile, 2, getTile("Land"))
				if lock == false:
					breakLayer = 0
				lock = true
	cooldown = .05

func restraintsGood(tile):
	var playerCoords = local_to_map(Player.position + Player.PlacePoint.position)
	if permaTiles.has(getTile(tile)):
		return false
	if abs(playerCoords.x - tile.x) >= 6:
		return false
	if abs(playerCoords.y - tile.y) >= 6:
		return false
	return true
