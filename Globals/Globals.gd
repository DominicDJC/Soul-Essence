extends Node

var itemData = {
	"SpikeTrap":{
		"tile":"Spike1",
		"type":"trap",
		"frame":2,
		"price":5
	},
	"StickyTrap":{
		"tile":"Sticky",
		"type":"trap",
		"frame":3,
		"price":2
	},
	"PoisonTrap":{
		"tile":"Poison",
		"type":"trap",
		"frame":4,
		"price":3
	},
	"SoulSeed":{
		"tile":"SoulStg1",
		"type":"crop",
		"frame":1,
		"price":1
	},
	"WeakWall":{
		"tile":"WeakWall",
		"type":"wall",
		"frame":5,
		"price":1
	},
	"AverageWall":{
		"tile":"AverageWall",
		"type":"wall",
		"frame":6,
		"price":2
	},
	"StrongWall":{
		"tile":"StrongWall",
		"type":"wall",
		"frame":7,
		"price":3
	},
	"Hoe":{
		"type":"hoe",
		"frame":0,
		"unlimited":true,
		"price":1
	},
	"Chest":{
		"tile":"Chest",
		"type":"storage",
		"frame":8,
		"price":10
	},
	"SoulEssence":{
		"type":"item",
		"frame":9
	},
	"Sword":{
		"type":"sword",
		"frame":10,
		"unlimited":true,
		"price":20
	},
}

var blockData = {
		"Land":{
			"atlus":Vector2i(0, 0),
			"breakLayer":-1
			},
		"Outside":{
			"atlus":Vector2i(1, 0),
			"breakLayer":-1
			},
		"Soil":{
			"atlus":Vector2i(2, 0),
			"breakLayer":0
		},
		"SoulStg1":{
			"atlus":Vector2i(3, 0),
			"breakLayer":1,
			"drops": ["SoulSeed"]
			},
		"SoulStg2":{
			"atlus":Vector2i(4, 0),
			"breakLayer":1,
			"drops":["SoulEssence", "SoulSeed"]
			},
		"WeakWall":{
			"atlus":Vector2i(0, 1),
			"breakLayer":0,
			"drops": ["WeakWall"]
		},
		"AverageWall":{
			"atlus":Vector2i(1, 1),
			"breakLayer":0,
			"drops": ["AverageWall"]
		},
		"StrongWall":{
			"atlus":Vector2i(2, 1),
			"breakLayer":0,
			"drops": ["StrongWall"]
		},
		"Spike1":{
			"atlus":Vector2i(0, 2),
			"breakLayer":0,
			"drops": ["SpikeTrap"]
		},
		"Spike2":{
			"atlus":Vector2i(1, 2),
			"breakLayer":0,
			"drops": ["SpikeTrap"]
		},
		"Sticky":{
			"atlus":Vector2i(2, 2),
			"breakLayer":0,
			"drops": ["StickyTrap"]
		},
		"Poison":{
			"atlus":Vector2i(3, 2),
			"breakLayer":0,
			"drops": ["PoisonTrap"]
		},
		"Chest":{
			"atlus":Vector2i(3, 1),
			"breakLayer":0,
			"drops": ["Chest"]
		}
	}

var cycle = 1
var time: int = 360
var timeFloat = 360.0
var timeScale = 15
var nightDay = "Day"


func _physics_process(delta):
	timeFloat += timeScale * delta
	if timeFloat > 1440:
		cycle += 1
		timeFloat = 0
	time = round(timeFloat)
	if time < 360 or time >= 1080:
		nightDay = "Night"
	else:
		nightDay = "Day"

func getItemData(item, request := []):
	var hold = {}
	if request == ["unlimited"]:
		if itemData.has(item) and itemData[item].has("unlimited") and itemData[item]["unlimited"]:
			return true
		else:
			return false
	if itemData.has(item):
		hold = itemData[item]
		for i in request:
			if hold.keys().has(i):
				if typeof(hold[i]) == TYPE_DICTIONARY:
					hold = hold[i]
				else:
					return hold[i]
			else:
				return ""
	else:
		return ""

func getAtluses():
	var dict = {}
	for key in blockData.keys():
		dict[key] = blockData[key]["atlus"]
	return dict

func getBlockData(block, request := []):
	var hold = {}
	if blockData.has(block):
		hold = blockData[block]
		for i in request:
			if hold.keys().has(i):
				if typeof(hold[i]) == TYPE_DICTIONARY:
					hold = hold[i]
				else:
					return hold[i]
			else:
				return ""
	else:
		return ""

func filterBlockData(key: String, value):
	var hold = {}
	for i in blockData.keys():
		if blockData[i].has(key) and blockData[i][key] == value:
			hold[i] = blockData[i][key]
	return hold

func blocksHaveAtlus(atlus: Vector2i):
	if typeof(atlus) == TYPE_VECTOR2I:
		print(blockData.keys())
		for i in blockData.keys():
			print(i)
			if blockData[i].has("atlus") and blockData[i]["atlus"] == atlus:
				return true
	return false
