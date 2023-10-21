extends Area2D

var contains = []


func _physics_process(delta):
	rotation = global_position.angle_to_point(get_global_mouse_position())

func objectEntered(body):
	if !contains.has(body):
		contains.push_back(body)

func objectExited(body):
	if contains.has(body):
		contains.erase(body)

func getEnemies():
	var array = []
	for i in contains:
		if ("type" in i) and i.type == "Enemy":
			array.push_back(i)
	return array
