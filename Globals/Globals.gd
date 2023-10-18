extends Node

var itemData = {
	"Crop1":{
		"Tile":"Crop1",
		"Type":"crop"
	},
	"Crop2":{
		"Tile":"Crop2",
		"Type":"crop"
	},
	"Crop3":{
		"Tile":"Crop3",
		"Type":"crop"
	},
	"Crop4":{
		"Tile":"Crop4",
		"Type":"crop"
	},
	"Hoe":{
		"Type":"hoe"
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
