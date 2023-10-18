extends Node

var itemData = {
	"SpikeTrap":{
		"tile":"Spike1",
		"type":"trap"
	},
	"StickyTrap":{
		"tile":"Sticky",
		"type":"trap"
	},
	"PoisonTrap":{
		"tile":"Crop3",
		"type":"trap"
	},
	"SoulSeed":{
		"tile":"SoulStg1",
		"type":"crop"
	},
	"WeakWall":{
		"tile":"Wall1",
		"type":"wall"
	},
	"AverageWall":{
		"tile":"Wall2",
		"type":"wall"
	},
	"StrongWall":{
		"tile":"Wall3",
		"type":"wall"
	},
	"Hoe":{
		"type":"hoe"
	}
}

var blockData = {
		"Land":{
			"atlus":Vector2i(0, 0),
			"breakLayer":0
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
			"breakLayer":1
			},
		"SoulStg2":{
			"atlus":Vector2i(4, 0),
			"breakLayer":1
			},
		"Wall1":{
			"atlus":Vector2i(0, 1),
			"breakLayer":0
		},
		"Wall2":{
			"atlus":Vector2i(1, 1),
			"breakLayer":0
		},
		"Wall3":{
			"atlus":Vector2i(2, 1),
			"breakLayer":0
		},
		"Spike1":{
			"atlus":Vector2i(0, 2),
			"breakLayer":0
		},
		"Spike2":{
			"atlus":Vector2i(1, 2),
			"breakLayer":0
		},
		"Sticky":{
			"atlus":Vector2i(2, 2),
			"breakLayer":0
		},
		"Poison":{
			"atlus":Vector2i(3, 2),
			"breakLayer":0
		}
	}

func getItemData(item, request := []):
	var hold = {}
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
		if blockData[i].has(key):
			hold[i] = blockData[i][key]
	return hold
