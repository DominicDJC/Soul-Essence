extends TileMap

@export var permaTiles: PackedStringArray
@export var Player: Node2D
@export var Hotbar: Control
var breakLayer = 0
var lock = false

func _physics_process(delta):
	if Input.is_action_pressed("place"):
			placeTile()
	if Input.is_action_pressed("remove"):
			clearTile()
	if Input.is_action_just_released("remove"):
		lock = false

func getTile(value):
	var dict = {
		"Land": Vector2i(6, 0),
		"Outside": Vector2i(7, 0),
		"Soil": Vector2i(6, 1),
		"Crop16": Vector2i(7, 1)
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
		elif item == "Crop16" and tileType == "Soil":
			set_cell(0, tile, 2, getTile("Crop16"))

func clearTile(localPosition: = get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	var tileType = getTile(tile)
	if lock == false:
		if tileType == "Crop16":
			breakLayer = 1
		elif tileType == "Soil":
			breakLayer = 0
		lock = true
	if restraintsGood(tile):
		if breakLayer == 1:
			if tileType == "Crop16":
				set_cell(0, tile, 2, getTile("Soil"))
		if breakLayer == 0:
			if tileType == "Soil":
				set_cell(0, tile, 2, getTile("Land"))

func restraintsGood(tile):
	var playerCoords = local_to_map(Player.position + Player.PlacePoint.position)
	if permaTiles.has(getTile(tile)):
		return false
	if abs(playerCoords.x - tile.x) >= 6:
		return false
	if abs(playerCoords.y - tile.y) >= 6:
		return false
	return true
