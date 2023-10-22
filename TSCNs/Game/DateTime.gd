extends Label

@onready var EnemyManager = $"../../../EnemyManager"

func _physics_process(delta):
	text = timeStandard() + "\n" + G.nightDay + ": " + str(G.cycle)

func dayNight():
	if G.time < 360 or G.time >= 1080:
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

func timeStandard(time := G.time):
	var hour = int(time / 60)
	var minute
	var amPM = "AM"
	if hour >= 12:
		hour -= 12
		amPM = "PM"
	if hour == 0:
		hour = 12
	if time % 60 >= 30:
		minute = "30"
	else:
		minute = "00"
	return str(hour) + ":" + minute + amPM
