extends Node2D

@onready var hero = $Hero
@onready var boats = $World/Boats

func _ready():
	hero.valid_word.connect(boats.on_valid_word)
