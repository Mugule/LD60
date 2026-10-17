extends Node2D

@onready var drone_scene : PackedScene = preload("res://Objects/drone.tscn")
@onready var attacked_scene : PackedScene = preload("res://Objects/attack.tscn")

var targets : Array = []

var spawn_left : float = -300
var spawn_right : float = 300

var timer_left : float = 30.0
var timer_max : float = 30.0
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
	var drone_instance : Drone = drone_scene.instantiate()
	add_child(drone_instance)
	var x : float = [spawn_left,spawn_right].pick_random()
	drone_instance.position = Vector2(x,-300)
	var target : Boat = targets.pick_random()
	drone_instance.target = target
	print("New drone with target : " +str(target.name))
	drone_instance.attack.connect(on_attacked_boat)
	drone_spawned.emit()

func on_attacked_boat(boat : Boat) :
	var attacked_node = attacked_scene.instantiate()
	add_child(attacked_node)
	attacked_node.position = boat.position
	attacked_node.get_node("AnimatedSprite2D").play("boom")
	boat.queue_free()
