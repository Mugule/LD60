extends Node2D

@onready var hero = $Hero
@onready var boats = $World/Boats
@onready var limits = $World/Limits
@onready var drones = $World/Drones
@onready var camera : Camera2D = $Camera2D

func _ready():
	# Limits
	camera.limits.position.y = limits.get_node("North").position.y + 180
	camera.limits.position.x = limits.get_node("West").position.x + 150
	camera.limits.end.x = limits.get_node("East").position.x - 90
	camera.limits.end.y = limits.get_node("South").position.y
	drones.spawn_left = limits.get_node("West").position.x
	drones.spawn_right = limits.get_node("East").position.x
	# Connections
	hero.valid_word.connect(boats.on_valid_word)
	# Targets adn Drones spawn
	for b in boats.get_children():
		drones.targets.append(b)
	$Hero/DroneUI.drones = drones
