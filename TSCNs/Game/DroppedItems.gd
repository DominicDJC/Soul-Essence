extends Node2D

@onready var dropped_item = preload("res://TSCNs/DroppedItem/dropped_item.tscn")

func dropItem(item, pos):
	var newDroppedItem = dropped_item.instantiate()
	newDroppedItem.Player = $"../Player"
	newDroppedItem.item = item
	newDroppedItem.position = pos
	add_child(newDroppedItem)
