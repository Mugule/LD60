class_name Drone extends Node2D

@export var speed : float = 30
var direction : Vector2 = Vector2.ZERO

func _process(delta):
	position += Vector2(-1,0) * delta * 30
