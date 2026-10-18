extends Node2D

@onready var hero = $Hero
@onready var boats = $World/Boats
@onready var limits = $World/Limits
@onready var drones = $World/Drones
@onready var drones_ui = $Hero/DroneUI
@onready var camera : Camera2D = $Camera2D

# Just some init parameters
func _ready():
	# Limits
	camera.limits.position.y = limits.get_node("North").position.y + 230 #(size + 50)
	camera.limits.position.x = limits.get_node("West").position.x + 150
	camera.limits.end.x = limits.get_node("East").position.x - 90
	camera.limits.end.y = limits.get_node("South").position.y
	drones.spawn_left = limits.get_node("West").position.x
	drones.spawn_right = limits.get_node("East").position.x
	# Connections
	hero.valid_word.connect(boats.on_valid_word)
	# Boat limits, targets and drones spawn
	for b in boats.get_children():
		drones.targets[b] = []
		b.cant_touch_me.connect(drones.on_saved_boat.bind(b))
		b.limits.position.y = limits.get_node("North").position.y
		b.limits.position.x = limits.get_node("West").position.x
		b.limits.end.x = limits.get_node("East").position.x 
		b.limits.end.y = limits.get_node("South").position.y
	drones_ui.drones = drones
	drones.drone_spawned.connect(drones_ui.refresh_text)
