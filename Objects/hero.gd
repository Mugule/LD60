extends Node

# Measurements
## Do the tititahtah
var time_pressed : float = 0.0
## Time when realesed and nothing happen
var time_nothing : float = 0.0
## Need to check if something will happen
var nothing_check : bool = false
# Final word
var letter : String

func _process(delta):
	# Please do not use ui_accept in real game. I'm just a lazy boy
	
	# PRESSED
	if Input.is_action_just_released("ui_accept"):
		nothing_check = true
		# Add short or long
		if time_pressed < MorseGlobal.short_time :
			letter += "."
		else :
			letter += "-"
		# Reset
		time_pressed = 0.0
	elif Input.is_action_pressed("ui_accept") :
		time_pressed += delta
	# SPACING
	if nothing_check :
		time_nothing += delta
		# If spacing, say the word
		if time_nothing > MorseGlobal.space_time :
			nothing_check = false
			if letter in MorseGlobal.letters :
				print(MorseGlobal.letters[letter])
			else :
				print("?")
			# Reset
			letter = ''
			time_nothing = 0.0
