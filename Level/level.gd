extends Node2D

@onready var hero = $Hero
@onready var boats = $World/Boats
@onready var limits = $World/Limits
@onready var drones = $World/Drones
@onready var drones_ui = $Hero/DroneUI
@onready var camera : Camera2D = $Camera2D

@onready var end_screen : ColorRect = $Hero/EndScreen
@onready var next_end_screen : Button = $Hero/EndScreen/Next

var game_end : bool = false
var timer_not_started : bool = true

# Just some init parameters
func _ready():
	end_screen.show()
	# Limits
	camera.limits.position.y = limits.get_node("North").position.y + 230 #(size + 50)
	camera.limits.position.x = limits.get_node("West").position.x + 150
	camera.limits.end.x = limits.get_node("East").position.x - 90
	camera.limits.end.y = limits.get_node("South").position.y
	drones.spawn_left = limits.get_node("West").position.x
	drones.spawn_right = limits.get_node("East").position.x
	# Connections
	$World/StartedDrone.area_entered.connect(start_timer_drones)
	hero.valid_word.connect(boats.on_valid_word)
	drones.no_target.connect(no_more_target)
	next_end_screen.pressed.connect(finish)
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
	var tween = create_tween()
	tween.tween_property(end_screen,"color:a",0.0,1.0)
	await tween.finished
	end_screen.hide()

func start_timer_drones(area):
	if timer_not_started : # drones.pause sometimes activated, have to use this
		if area.get_parent() is Boat :
			timer_not_started = false
			drones.paused = false

## EMITTED by drones when update boat if saved or attacked.
func no_more_target() :
	if !game_end : # I dont know why I put this here, I'm tired boss.
		game_end = true
		end_game()

func end_game() :
	drones.paused = true
	end_screen.show()
	var tween = create_tween()
	tween.tween_property(end_screen,"color:a",1.0,1.0)
	await tween.finished
	var drones_dead : int = drones.drones_dead
	var drone_text = "\n %s drones killed" % str(drones_dead)
	var boat_saved : int = boats.get_child_count()
	var boat_text = "\n %s/5 boat saved" % str(boat_saved)
	if boat_saved == 5 :
		end_screen.get_node("TotalWin").show()
		await get_tree().create_timer(1.0).timeout
		end_screen.get_node("TotalWin").text += drone_text
	elif boat_saved > 0 :
		end_screen.get_node("PartialWin").show()
		await get_tree().create_timer(1.0).timeout
		end_screen.get_node("PartialWin").text += boat_text
		await get_tree().create_timer(1.0).timeout
		end_screen.get_node("PartialWin").text += drone_text
	else :
		end_screen.get_node("GameOver").show()
		await get_tree().create_timer(1.0).timeout
		end_screen.get_node("GameOver").text += drone_text
	await get_tree().create_timer(1.0).timeout
	next_end_screen.show()
	end_screen.grab_focus()

func finish() :
	if end_screen.get_node("Credits").visible :
		ResourceLoader.load_threaded_request("res://Menu/main_menu.tscn")
		var packed_scene = ResourceLoader.load_threaded_get("res://Menu/main_menu.tscn")
		get_tree().change_scene_to_packed(packed_scene)
	else :
		end_screen.get_node("GameOver").hide()
		end_screen.get_node("PartialWin").hide()
		end_screen.get_node("TotalWin").hide()
		end_screen.get_node("Credits").show()
