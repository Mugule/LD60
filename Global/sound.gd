extends Node



func play(fx_name : String) :
	var fx : AudioStreamPlayer = get_node(fx_name.to_pascal_case())
	fx.play()

func tone_released():
	$Tone.stop()
