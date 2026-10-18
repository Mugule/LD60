extends Node2D

func _ready():
	print("BOOM")
	Sound.play("explosion")
	$AnimatedSprite2D.play("boom")
	$AnimatedSprite2D.animation_finished.connect(dead_guys)

func dead_guys():
	$AnimatedSprite2D.play("dead")
