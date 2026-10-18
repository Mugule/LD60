extends Node

var m1 : AudioStreamWAV = preload("res://Sounds/music/bass_only.wav")
var m2 : AudioStreamWAV = preload("res://Sounds/music/idunno.wav")
var m3 : AudioStreamWAV = preload("res://Sounds/music/solo1.wav")
var m4 : AudioStreamWAV = preload("res://Sounds/music/solo2.wav")
var m5 : AudioStreamWAV = preload("res://Sounds/music/song1.wav")
var m6 : AudioStreamWAV = preload("res://Sounds/music/yahou.wav")

func _ready():
	$Music.finished.connect(music_play)
	music_play(m1)

func play(fx_name : String) :
	var fx : AudioStreamPlayer = get_node(fx_name.to_pascal_case())
	fx.play()

func tone_released():
	$Tone.stop()

func music_play(forced : AudioStreamWAV = null):
	if forced :
		$Music.stream = forced
	else :
		$Music.stream = [m2,m3,m4,m5,m6].pick_random()
	$Music.play()
