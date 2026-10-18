extends TextureButton

var active : bool = true

func _ready():
	pressed.connect(on_pressed)

func on_pressed():
	active = !active
	if active :
		Sound.music_on()
		get_node("False").show()
	else :
		Sound.sound_off()
		get_node("False").hide()
