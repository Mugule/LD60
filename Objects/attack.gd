extends Node2D

func _ready():
	$AnimatedSprite2D.animation_finished.connect(dead_guys)

func dead_guys():
	$AnimatedSprite2D.play("dead")
