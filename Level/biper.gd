extends Button

# Measurements
var time_pressed : float = 0.0
var bip_pressed : bool = false
var bip_just_released : bool = false
var tah_emited : bool = false

signal ti
signal tah
signal bip_end

func _ready():
	button_down.connect(on_pressed)
	button_up.connect(on_released)

func _process(delta):
	# Please do not use ui_accept in real game. I'm just a lazy boy
	# PRESSED
	if bip_pressed :
		time_pressed += delta
		if !tah_emited :
			if time_pressed > MorseGlobal.short_time :
				tah_emited = false
				bip_pressed = false
				tah.emit()

func _input(event):
	if event.is_action_pressed("ui_accept") :
		ti_emit()
	elif event.is_action_released("ui_accept") :
		bip_released()

func on_pressed():
	ti_emit()
func on_released():
	bip_released()

func bip_released():
	Sound.tone_released()
	bip_end.emit()
	bip_pressed = false
	time_pressed = 0.0
func ti_emit():
	Sound.play("tone")
	tah_emited = false
	bip_pressed = true
	ti.emit()
