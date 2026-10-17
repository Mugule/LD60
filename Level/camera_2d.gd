extends Camera2D

var mouse_is_pressed : bool = false
var origin_click : Vector2
var origin_camera : Vector2
var camera_speed : float = 254
var limits : Rect2 = Rect2(-100,-200, 460, 460)

var blocked : bool

# I dont use limit of camera2D because I dont have time to watch tuto for it.

func _ready():
	origin_camera = Vector2(180,180)

# CAMERA MOVEMENT

func _process(delta):
	if !blocked :
		if mouse_is_pressed :
			var delta_pos : Vector2 = get_viewport().get_mouse_position() - origin_click
			var p : Vector2 = origin_camera - delta_pos
			global_position = p.clamp(limits.position, limits.end)
		else :
			var direction : Vector2 = Vector2.ZERO
			if Input.is_action_pressed("ui_up"):
				direction += Vector2.UP
			elif Input.is_action_pressed("ui_down"):
				direction += Vector2.DOWN
			if Input.is_action_pressed("ui_left"):
				direction += Vector2.LEFT
			elif Input.is_action_pressed("ui_right"):
				direction += Vector2.RIGHT
			var p : Vector2 = position + (direction * (delta * camera_speed))
			global_position = p.clamp(limits.position, limits.end)

func _input(_event):
	if !blocked :
		# MOVE by CLICK
		if Input.is_action_just_pressed("mouse_click") :
			mouse_is_pressed = true
			origin_camera = global_position
			origin_click = get_viewport().get_mouse_position()
		elif Input.is_action_just_released("mouse_click") :
			mouse_is_pressed = false
	else :
		if mouse_is_pressed :
			mouse_is_pressed = false
