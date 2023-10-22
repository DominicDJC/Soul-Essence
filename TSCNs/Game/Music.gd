extends AudioStreamPlayer

const FADE_OUT_TIME = 5
const FADE_IN_TIME = 20
var dayTrack = preload("res://Music/day loop.wav")
var nightTrack = preload("res://Music/night loop.wav")
var dayPosition = 0.0
var nightPosition = 0.0
var nightDay = "Day"
var nightDayOld = "Day"


func _ready():
	volume_db = -40
	stream = dayTrack
	fadeIn(dayPosition)

func _process(delta):
	if G.time < 360 - (G.timeScale * FADE_OUT_TIME) or G.time >= 1080 - (G.timeScale * FADE_OUT_TIME):
		nightDay = "Night"
	else:
		nightDay = "Day"
	if nightDayOld != nightDay:
		nightDayOld = nightDay
		if nightDayOld == "Day":
			nightPosition = await fadeOut()
			stream = dayTrack
			fadeIn(dayPosition)
		else:
			dayPosition = await fadeOut()
			stream = nightTrack
			fadeIn(nightPosition)

func fadeOut():
	var tween = get_tree().create_tween()
	var position = get_playback_position()
	tween.tween_property(self, "volume_db", -50, FADE_OUT_TIME)
	await tween.finished
	stop()
	return position

func fadeIn(position):
	play(position)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", -23, FADE_IN_TIME)

func finished():
	play()
