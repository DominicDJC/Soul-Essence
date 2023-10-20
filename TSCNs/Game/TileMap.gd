extends TileMap

@onready var Chest = preload("res://TSCNs/Chest/chest.tscn")
@onready var Crop = preload("res://TSCNs/Crop/crop.tscn")
@onready var DroppedItems = $"../DroppedItems"
@onready var Player = $"../Player"
@export var permaTiles: PackedStringArray
var breakLayer = 0
var lock = false

func getTile(value):
	var dict = G.getAtluses()
	if typeof(value) == TYPE_VECTOR2I:
		for key in dict.keys():
			if dict[key] == get_cell_atlas_coords(0, value):
				return key
		return "unknown"
	else:
		if dict.has(value):
			return dict[value]
		return Vector2i(0, 0)

func placeTile(item, localPosition := get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	var tileType = getTile(tile)
	if restraintsGood(tile):
		var itemTile = G.getItemData(item, ["tile"])
		var itemType = G.getItemData(item, ["type"])
		if item == "Hoe" and tileType == "Land":
			set_cell(0, tile, 2, getTile("Soil"))
		elif itemType != "" and itemTile != "":
			match tileType:
				"Soil":
					match itemType:
						"crop":
							set_cell(0, tile, 2, getTile(itemTile))
							createCrop(tile)
				"Land":
					match itemType:
						"trap", "wall", "storage":
							set_cell(0, tile, 2, getTile(itemTile))
							if itemType == "storage":
								createChest(tile)
	if tileType != getTile(tile):
		return true
	else:
		return false

func setTile(tile, tileName):
	set_cell(0, tile, 2, getTile(tileName))

func clearTile(localPosition := get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	var tileName = getTile(tile)
	if (tileName == "Chest" and getChest(tile).isEmpty()) or tileName != "Chest":
		if restraintsGood(tile):
			if lock == false:
				breakLayer = G.getBlockData(tileName, ["breakLayer"])
			if G.filterBlockData("breakLayer", breakLayer).keys().has(tileName):
				match breakLayer:
					1:
						set_cell(0, tile, 2, getTile("Soil"))
						if tileName == "SoulStg1" or tileName == "SoulStg2":
							destroyCrop(tile)
					0:
						set_cell(0, tile, 2, getTile("Land"))
						if tileName == "Chest":
							destroyChest(tile)
				var drop = G.getBlockData(tileName, ["drops"])
				if drop != "":
					DroppedItems.dropItem(drop, localPosition)
			lock = true

func restraintsGood(tile):
	var playerCoords = local_to_map(Player.position)
	if permaTiles.has(getTile(tile)):
		return false
	if abs(playerCoords.x - tile.x) >= 6:
		return false
	if abs(playerCoords.y - tile.y) >= 6:
		return false
	return true

func createChest(tile):
	var c = Chest.instantiate()
	c.tile = tile
	c.type = "Chest"
	add_child(c)

func destroyChest(tile):
	getChest(tile).queue_free()

func getChest(tile := local_to_map(get_local_mouse_position())):
	for i in get_children():
		if i.type == "Chest" and i.tile == tile:
			return i

func createCrop(tile):
	var c = Crop.instantiate()
	c.tile = tile
	c.type = "Crop"
	add_child(c)

func destroyCrop(tile):
	getCrop(tile).queue_free()

func getCrop(tile := local_to_map(get_local_mouse_position())):
	for i in get_children():
		if i.type == "Crop" and i.tile == tile:
			return i

func centerPosition(pos := get_local_mouse_position()):
	return map_to_local(local_to_map(pos))

func posTile(pos := get_local_mouse_position()):
	return getTile(local_to_map(pos))
