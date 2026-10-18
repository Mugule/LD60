class_name Boat extends Node2D

@onready var civilian_sprite : AnimatedSprite2D = $Civilian
@onready var guard_sprite : AnimatedSprite2D = $Guard
@onready var guard_area : Area2D = $GuardRange
@onready var guard_range : Sprite2D = $GuardRangeViz
var sprite : AnimatedSprite2D
@onready var pivot : Node2D = $Pivot
@onready var bang : AnimatedSprite2D = $Pivot/Bang
@onready var id_node : Label = $Id
@onready var horizontal_collision_shape : CollisionShape2D = $Area2D/HorizontalCollisionShape
@onready var vertical_collision_shape : CollisionShape2D = $Area2D/VerticalCollisionShape
@onready var area_2d : Area2D = $Area2D
@onready var particule : CPUParticles2D = $CPUParticles2D

# I know that I have to use area and stuff but I didn't succed so I will 
# calculate it with good old clamp
var limits : Rect2 = Rect2(-1000,-1000, 2000, 2000)

# I mean, I should do something way better, like Boat is a master class of 
# my civilian and my guard boat. But I never do this and I'm not going to watch
# some void tutorial video on Youtube. If you read me to improve just don't. 
enum BoatType {CIVILIAN, GUARD} 
@export var boat_type : BoatType

var speed : float = 6.0
var actual_direction : Vector2 = Vector2.ZERO
var targets_guard : Array = []
var shoot_cooldown : float = 1.0
var cd : float = 1.0

var safe : bool = false

var obstacle : Area2D = null

signal cant_touch_me

var orders : Dictionary = {
	"O" : Vector2.ZERO,
	"N" : Vector2.UP,
	"E" : Vector2.RIGHT,
	"S" : Vector2.DOWN,
	"W" : Vector2.LEFT
}

func _ready():
	if str(name) == "Boat":
		name = "A"
	var aftername : String = MorseGlobal.letters.find_key(str(name))
	id_node.text = name + aftername
	area_2d.area_entered.connect(on_area_entered)
	area_2d.area_exited.connect(on_area_exited)
	if boat_type == BoatType.GUARD :
		# SPRITE
		sprite = guard_sprite
		guard_sprite.show()
		civilian_sprite.hide()
		# AREA 2D
		guard_range.show()
		guard_area.area_entered.connect(object_in_range)
		guard_area.area_exited.connect(object_out_range)
	else :
		# SPRITE
		sprite = civilian_sprite
		civilian_sprite.show()
		guard_sprite.hide()
		# AREA 2D
		guard_area.monitoring = false
		guard_area.monitorable = false
	var names : Array = sprite.sprite_frames.get_animation_names()
	sprite.play(names.pick_random())

func _physics_process(delta):
	if safe :
		position += Vector2.UP * (delta * speed * 1.5)
	else :
		var p : Vector2 = global_position + actual_direction * (delta * speed)
		if obstacle :
			var diff : Vector2 = obstacle.global_position - global_position
			diff = diff.normalized()
			p -= diff * (delta * speed)
		global_position = p.clamp(limits.position, limits.end)
		# BANG MANAGEMENT
		if targets_guard.size() > 0 :
			if targets_guard[0] is Drone :
				if cd <= 0 :
					var aim : Vector2 = targets_guard[0].global_position - global_position
					pivot.rotation = aim.angle()
					bang.play("default")
					targets_guard[0].shooted()
					cd = 1.0
				else :
					cd -= delta
			else :
				targets_guard.pop_front()

func on_order_received(new_order):
	if new_order in orders :
		actual_direction = orders[new_order]
		# Collision and Keep actual collision
		if actual_direction == Vector2.ZERO :
			particule.emitting = false
		# Particules and check collision
		if actual_direction == Vector2.UP : # NORTH
			horizontal_collision_shape.disabled = false
			vertical_collision_shape.disabled = true
			particule.emitting = true
			particule.direction = Vector2(0,1)
			particule.position = Vector2(0,6)
		elif actual_direction == Vector2.DOWN : # SOUTH
			horizontal_collision_shape.disabled = false
			vertical_collision_shape.disabled = true
			particule.emitting = true
			particule.direction = Vector2(0,-1)
			particule.position = Vector2(0,-4)
		elif actual_direction == Vector2.LEFT : # WEST
			horizontal_collision_shape.disabled = true
			vertical_collision_shape.disabled = false
			particule.emitting = true
			particule.direction = Vector2(1,-0.5)
			particule.position = Vector2(6,3)
		elif actual_direction == Vector2.RIGHT : # EAST
			horizontal_collision_shape.disabled = true
			vertical_collision_shape.disabled = false
			particule.emitting = true
			particule.direction = Vector2(-1,-0.5)
			particule.position = Vector2(-6,3)
		# Animation
		if new_order in sprite.sprite_frames.get_animation_names() :
			sprite.play(new_order)

func on_area_exited(_area : Area2D):
	var areas : Array[Area2D] = area_2d.get_overlapping_areas()
	obstacle = null
	for a in areas :
		var x = a.get_parent()
		if x is Boat or x is Rock :
			obstacle = a

func on_area_entered(area : Area2D):
	var x = area.get_parent()
	if x is Boat or x is Rock :
		particule.emitting = false
		actual_direction = Vector2.ZERO
		obstacle = area

func object_in_range(area : Area2D) :
	if area.get_parent() is Drone :
		targets_guard.append(area.get_parent())

func object_out_range(area : Area2D) :
	if area.get_parent() is Drone :
		targets_guard.erase(area.get_parent())

func saved() :
	print("I'm SAFE !")
	safe = true
	cant_touch_me.emit()
