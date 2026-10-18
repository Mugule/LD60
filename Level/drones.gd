extends Node2D

@onready var drone_scene : PackedScene = preload("res://Objects/drone.tscn")
@onready var attacked_scene : PackedScene = preload("res://Objects/attack.tscn")

var targets : Dictionary = {}

var spawn_left : float = -300
var spawn_right : float = 300

var timer_left : float = 5.0
var timer_max : float = 5.0
var ratio : float = 1.0

var paused : bool = false

signal drone_spawned

func _physics_process(delta):
	if !paused :
		if timer_left > 0 :
			timer_left -= delta * ratio
		else :
			paused = true
			spawn_drone()

func spawn_drone():
	# check first if target left
	if targets.size() > 0 :
		var target : Boat = targets.keys().pick_random()
		var drone_instance : Drone = drone_scene.instantiate()
		add_child(drone_instance)
		var x : float = [spawn_left,spawn_right].pick_random()
		drone_instance.position = Vector2(x,-300)
		drone_instance.origin_spawn.x = x
		drone_instance.target = target
		targets[target].append(drone_instance)
		print("New drone with target : " +str(target.name))
		drone_instance.attack.connect(on_attacked_boat)
		target.cant_touch_me.connect(drone_instance.on_saved_target)
		drone_spawned.emit()
		# Go back to spawn
		timer_left = timer_max
		ratio += 0.1
		paused = false
	else :
		print("No spawn, no boat to attack")

func on_attacked_boat(boat : Boat) :
	var attacked_node = attacked_scene.instantiate()
	add_child(attacked_node)
	attacked_node.global_position = boat.global_position
	await delete_boat_targets(boat)
	boat.queue_free()

func on_saved_boat(boat : Boat) :
	await delete_boat_targets(boat)
	print("targets " + str(targets))

func delete_boat_targets(boat : Boat) :
	if targets.has(boat):
		for dro in targets[boat] :
			
