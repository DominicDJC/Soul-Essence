extends Sprite2D


func update(current, max):
	if current <= 0:
		visible = false
	else:
		var rounding = round( ( float(current) / float(max) ) * 20 )
		frame = rounding - 1
		visible = true
