extends Label


func _physics_process(delta):
	text = "Time: " + time() + "\n" + dayNight() + str(G.cycle)

func dayNight():
	if G.time >= 720:
		return "Night: "
	else:
		return "Day: "

func time():
	var hour = str(int(G.time / 60))
	var minute
	if G.time % 60 >= 30:
		minute = "30"
	else:
		minute = "00"
	return hour + ":" + minute
