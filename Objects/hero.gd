extends Node2D

const SPEED : float = 254



func _process(delta):
	
	# X DIRECTION
	var direction : float
	# Please do not use ui_let in real game. I'm just a lazy boy
	if Input.is_action_pressed("ui_left") :
		direction = -1
	elif Input.is_action_pressed("ui_right") :
		direction = 1
	position.x += delta * direction * SPEED
	
	# Y DIRECTION
	
