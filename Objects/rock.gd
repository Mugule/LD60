class_name Rock extends Node2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d : Area2D = $Area2D

enum RockType {SMALL, MEDIUM, BIG}
@export var rock_type : RockType

func _ready():
	# Sprite and collision node
	if rock_type == RockType.SMALL :
		sprite.play("small")
		area_2d.get_node("Small").disabled = false
	elif rock_type == RockType.MEDIUM :
		sprite.play("medium")
		area_2d.get_node("Medium").disabled = false
	elif rock_type == RockType.BIG :
		sprite.play("big")
		area_2d.get_node("Big").disabled = false
