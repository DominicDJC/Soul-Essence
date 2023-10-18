extends TileMap

@export var permaTiles: PackedStringArray
@export var Player: Node2D
@export var Hotbar: Control
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
				"Land":
					match itemType:
						"trap", "wall":
							set_cell(0, tile, 2, getTile(itemTile))

func clearTile(localPosition := get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	var tileName = getTile(tile)
	if restraintsGood(tile):
		if lock == false:
			breakLayer = G.getBlockData(tileName, ["breakLayer"])
		if G.filterBlockData("breakLayer", breakLayer).keys().has(tileName):
			match breakLayer:
				1:
					set_cell(0, tile, 2, getTile("Soil"))
				0:
					set_cell(0, tile, 2, getTile("Land"))
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

func mouseOverTile():
	return getTile(local_to_map(get_local_mouse_position()))
