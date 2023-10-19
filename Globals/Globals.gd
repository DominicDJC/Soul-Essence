extends Node

var itemData = {
	"SpikeTrap":{
		"tile":"Spike1",
		"type":"trap",
		"frame":2
	},
	"StickyTrap":{
		"tile":"Sticky",
		"type":"trap",
		"frame":3
	},
	"PoisonTrap":{
		"tile":"Crop3",
		"type":"trap",
		"frame":4
	},
	"SoulSeed":{
		"tile":"SoulStg1",
		"type":"crop",
		"frame":1
	},
	"WeakWall":{
		"tile":"Wall1",
		"type":"wall",
		"frame":5
	},
	"AverageWall":{
		"tile":"Wall2",
		"type":"wall",
		"frame":6
	},
	"StrongWall":{
		"tile":"Wall3",
		"type":"wall",
		"frame":7
	},
	"Hoe":{
		"type":"hoe",
		"frame":0,
		"unlimited":true
	}
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
			"drops": "SoulSeed"
			},
		"SoulStg2":{
			"atlus":Vector2i(4, 0),
			"breakLayer":1
			},
		"Wall1":{
			"atlus":Vector2i(0, 1),
			"breakLayer":0,
			"drops": "Wall1"
		},
		"Wall2":{
			"atlus":Vector2i(1, 1),
			"breakLayer":0,
			"drops": "Wall2"
		},
		"Wall3":{
			"atlus":Vector2i(2, 1),
			"breakLayer":0,
			"drops": "Wall3"
		},
		"Spike1":{
			"atlus":Vector2i(0, 2),
			"breakLayer":0,
			"drops": "SpikeTrap"
		},
		"Spike2":{
			"atlus":Vector2i(1, 2),
			"breakLayer":0,
			"drops": "SpikeTrap"
		},
		"Sticky":{
			"atlus":Vector2i(2, 2),
			"breakLayer":0,
			"drops": "StickyTrap"
		},
		"Poison":{
			"atlus":Vector2i(3, 2),
			"breakLayer":0,
			"drops": "PoisonTrap"
		}
	}

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
