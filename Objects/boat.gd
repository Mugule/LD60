class_name Boat extends Node2D

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var id_node : Label = $Id

@export var speed_1 : float = 6.0
@export var speed_2 : float = 10.0

var actual_speed : float
var actual_direction : Vector2 = Vector2.ZERO

var orders : Dictionary = {
	"NO" : Vector2.ZERO,
	"NN" : Vector2.UP,
	"EE" : Vector2.RIGHT,
	"SS" : Vector2.DOWN,
	"WW" : Vector2.LEFT
}

func _ready():
	var aftername : String = MorseGlobal.letters.find_key(str(name))
	id_node.text = name + aftername

func _physics_process(delta):
	position += actual_direction * (delta * actual_speed)

func on_order_received(new_order):
	if new_order in orders :
		if actual_direction == orders[new_order] :
			actual_speed = speed_2
		else :
			actual_direction = orders[new_order]
			actual_speed = speed_1
		# Animation
		if new_order in sprite.sprite_frames.get_animation_names() :
			sprite.play(new_order)
