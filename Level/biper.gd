extends Button

# Measurements
var time_pressed : float = 0.0
var bip_pressed : bool = false
var bip_just_released : bool = false

signal bip(String)

func _ready():
	button_down.connect(on_pressed)
	button_up.connect(on_released)

func _process(delta):
	# Please do not use ui_accept in real game. I'm just a lazy boy
	# PRESSED
	if bip_just_released:
		bip_just_released = false
		bip_pressed = false
		# Add short or long
		if time_pressed < MorseGlobal.short_time :
			bip.emit(".")
		else :
			bip.emit("-")
		# Reset
		time_pressed = 0.0
	elif bip_pressed :
		time_pressed += delta

func _input(event):
	if event.is_action_pressed("ui_accept") :
		bip_pressed = true
	elif event.is_action_released("ui_accept") :
		bip_just_released = true

func on_pressed():
	bip_pressed = true
func on_released():
	bip_just_released = true
