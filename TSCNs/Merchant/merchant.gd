extends Node2D

@onready var MerchantUI = $MerchantUI
@onready var Sprite = $Sprite
@onready var textureBuilder = preload("res://Textures/Merchants/BuilderGuy.png")
@onready var texturePlant = preload("res://Textures/Merchants/PlantGuy.png")
@onready var textureTrap = preload("res://Textures/Merchants/TrapGuy.png")
@onready var textureWeapon = preload("res://Textures/Merchants/WeaponsGuy.png")
const ITEMS_COUNT = 3
var Player: Node2D
var type = ""
var items = []
var rng = RandomNumberGenerator.new()
var mouseIn = false
var target
var speed = 50
var origin
signal done


func _ready():
	match type:
		"BuilderGuy":
			Sprite.texture = textureBuilder
		"TrapGuy":
			Sprite.texture = textureTrap
		"PlantGuy":
			Sprite.texture = texturePlant
		"WeaponsGuy":
			Sprite.texture = textureWeapon
	origin = Vector2i(250 + rng.randi_range(0, 50), 500)
	position = origin
	target = Vector2i(origin.x, 300)
	rng.randomize()
	prepareItems()
	MerchantUI.visible = false
	await get_tree().create_timer(30).timeout
	if Inventory.openedMerchant == self:
		await Inventory.merchant_close
	target = origin

func _physics_process(delta):
	Sprite.flip_h = (Player.position.x < position.x)
	if G.nightDay == "Night":
		target = origin
	if position.distance_to(target) > 15:
		if Inventory.openedMerchant != self:
			if target == origin:
				position.y += speed * delta
			else:
				position.y -= speed * delta
	else:
		if target == origin:
			done.emit()
			get_parent().remove_child(self)
			queue_free()
	
	if mouseIn and position.distance_to(Player.position) < 110 and !(target == origin and position.distance_to(target) < 20):
		if !Player.merchants.has(self):
			Player.merchants.push_back(self)
	else:
		if Player.merchants.has(self):
			Player.merchants.erase(self)

func prepareItems():
	items = []
	var pool = itemPool(type)
	for i in ITEMS_COUNT:
		var randomInt = rng.randi_range(0, pool.size() - 1)
		items.push_back(pool[randomInt])
		pool.pop_at(randomInt)
	MerchantUI.prepareMerchant(items)

func itemPool(type):
	match type:
		"TrapGuy":
			return ["SpikeTrap", "StickyTrap", "PoisonTrap", "Directional", "Turret"]
		"BuilderGuy":
			return ["WeakWall", "AverageWall", "StrongWall", "Chest"]
		"WeaponsGuy":
			return ["Hoe", "Sword", "Slingshot"]
		"PlantGuy":
			return ["SoulSeed", "SoulSeed", "SoulSeed"]

func mouseEntered():
	mouseIn = true

func mouseExited():
	mouseIn = false
