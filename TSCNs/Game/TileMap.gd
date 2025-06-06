extends TileMap

@onready var Chest = preload("res://TSCNs/Chest/chest.tscn")
@onready var Crop = preload("res://TSCNs/Crop/crop.tscn")
@onready var Wall = preload("res://TSCNs/Wall/wall.tscn")
@onready var SpikeTrap = preload("res://TSCNs/SpikeTrap/spiketrap.tscn")
@onready var StickyTrap = preload("res://TSCNs/StickyTrap/stickytrap.tscn")
@onready var PoisonTrap = preload("res://TSCNs/PoisonTrap/poisontrap.tscn")
@onready var Directional = preload("res://TSCNs/Directional/directional.tscn")
@onready var Turret = preload("res://TSCNs/Turret/turret.tscn")
@onready var DroppedItems = $"../DroppedItems"
@onready var Player = $"../Player"
@export var permaTiles: PackedStringArray
var breakLayer = 0
var lock = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

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
			setTile(tile, "Soil")
		elif itemType != "" and itemTile != "":
			match tileType:
				"Soil":
					match itemType:
						"crop":
							setTile(tile, itemTile)
							createCrop(tile)
				"Land":
					match itemType:
						"trap", "wall", "storage", "projectile":
							setTile(tile, itemTile)
							match itemType:
								"storage":
									createChest(tile)
								"wall":
									createWall(tile, itemTile)
								"trap":
									match itemTile:
										"Spike1":
											createTrap(tile, "SpikeTrap")
										"Sticky":
											createTrap(tile, "StickyTrap")
										"Poison":
											createTrap(tile, "PoisonTrap")
								"projectile":
									createProjectile(tile, itemTile)
	if tileType != getTile(tile):
		return true
	else:
		return false

func setTile(tile, tileName):
	set_cell(0, tile, 2, getTile(tileName))

func clearTile(localPosition := get_local_mouse_position()):
	var tile: Vector2i = local_to_map(localPosition)
	if G.blocksHaveAtlus(get_cell_atlas_coords(0, tile)):
		var tileName = getTile(tile)
		if (tileName == "Chest" and getChest(tile).isEmpty()) or tileName != "Chest":
			if restraintsGood(tile):
				if lock == false:
					breakLayer = G.getBlockData(tileName, ["breakLayer"])
				if G.filterBlockData("breakLayer", breakLayer).keys().has(tileName):
					match breakLayer:
						1:
							setTile(tile, "Soil")
							if tileName == "SoulStg1" or tileName == "SoulStg2":
								destroyCrop(tile)
						0:
							setTile(tile, "Land")
							match tileName:
								"Chest":
									destroyChest(tile)
								"WeakWall", "AverageWall", "StrongWall":
									destroyWall(tile)
								"Spike1", "Spike2":
									destroyTrap("SpikeTrap", tile)
								"Sticky":
									destroyTrap("StickyTrap", tile)
								"Poison":
									destroyTrap("PoisonTrap", tile)
								"Directional", "Turret":
									destroyProjectile(tileName, tile)
					var drops = G.getBlockData(tileName, ["drops"])
					if tileName == "SoulStg2" and rng.randi_range(0, 2) == 0:
						DroppedItems.dropItem("SoulSeed", localPosition + Vector2(rng.randi_range(-10, 10), rng.randi_range(-10, 10)))
					for drop in drops:
						DroppedItems.dropItem(drop, localPosition + Vector2(rng.randi_range(-10, 10), rng.randi_range(-10, 10)))
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
	c.position = map_to_local(tile)
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
	c.position = map_to_local(tile)
	add_child(c)

func destroyCrop(tile):
	getCrop(tile).queue_free()

func getCrop(tile := local_to_map(get_local_mouse_position())):
	for i in get_children():
		if i.type == "Crop" and i.tile == tile:
			return i

func getCrops():
	var array = []
	for i in get_children():
		if i.type == "Crop":
			array.push_back(i)
	return array

func createWall(tile, type):
	var w = Wall.instantiate()
	w.tile = tile
	w.type = "Wall"
	w.position = map_to_local(tile)
	w.WorldMap = self
	match type:
		"WeakWall":
			w.health = 10
		"AverageWall":
			w.health = 20
		"StrongWall":
			w.health = 30
	add_child(w)

func destroyWall(tile):
	getWall(tile).queue_free()

func getWall(tile := local_to_map(get_local_mouse_position())):
	for i in get_children():
		if i.type == "Wall" and i.tile == tile:
			return i

func createTrap(tile, type):
	var t
	match type:
		"SpikeTrap":
			t = SpikeTrap.instantiate()
		"StickyTrap":
			t = StickyTrap.instantiate()
		"PoisonTrap":
			t = PoisonTrap.instantiate()
	t.tile = tile
	t.type = type
	t.position = map_to_local(tile)
	t.WorldMap = self
	add_child(t)

func destroyTrap(type, tile):
	getTrap(type, tile).queue_free()

func getTrap(type, tile := local_to_map(get_local_mouse_position())):
	for i in get_children():
		if i.type == type and i.tile == tile:
			return i

func createProjectile(tile, type):
	var p
	match type:
		"Directional":
			p = Directional.instantiate()
		"Turret":
			p = Turret.instantiate()
	p.tile = tile
	p.type = type
	p.position = map_to_local(tile)
	p.WorldMap = self
	add_child(p)

func destroyProjectile(type, tile):
	getProjectile(type, tile).queue_free()

func getProjectile(type, tile := local_to_map(get_local_mouse_position())):
	for i in get_children():
		if i.type == type and i.tile == tile:
			return i

func centerPosition(pos := get_local_mouse_position()):
	return map_to_local(local_to_map(pos))

func posTile(pos := get_local_mouse_position()):
	return getTile(local_to_map(pos))

func enemyKillTile(tile, enemy, child):
	var tileName = getTile(tile)
	match tileName:
		"SoulStg1", "SoulStg2":
			for i in G.getBlockData(tileName, ["drops"]):
				enemy.holding.push_back(i)
			setTile(tile, "Soil")
			destroyCrop(tile)
		"WeakWall", "AverageWall", "StrongWall", "Directional", "Turret":
			setTile(tile, "Land")
			remove_child(child)
			child.queue_free()
