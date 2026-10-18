extends TextureRect

var started_pos : Vector2 = Vector2(262,222) # never hardcode this like me plz

var tween : Tween

func outline_on():
	$Outline.show()

func outline_off():
	$Outline.hide()

func clicked():
	if tween : tween.kill()
	global_position.y = started_pos.y + 3

func unclicked():
	if tween : tween.kill()
	tween = create_tween()
	tween.tween_property(self,"position:y",started_pos.y,0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
