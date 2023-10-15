extends TileMap

@export var permaTiles: Array

func _physics_process(delta):
	if Input.is_action_pressed("place"):
			placeTile()
	if Input.is_action_pressed("remove"):
			clearTile()


func placeTile(localPosition: = get_local_mouse_position()):
	var tile: Vector2 = local_to_map(localPosition)
	if check(tile):
		set_cell(0, tile, 2, Vector2i(6, 1))

func clearTile(localPosition: = get_local_mouse_position()):
	var tile: Vector2 = local_to_map(localPosition)
	if check(tile):
		set_cell(0, tile, 2, Vector2i(6, 0))

func check(tile):
	var atlasCoords = get_cell_atlas_coords(0, tile)
	if permaTiles.has(atlasCoords):
		return false
	return true
