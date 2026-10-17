class_name Boat extends Node2D

@onready var sprite : AnimatedSprite2D = $Sprite
@onready var id_node : Label = $Id
@onready var horizontal_collision_shape : CollisionShape2D = $Area2D/HorizontalCollisionShape
@onready var vertical_collision_shape : CollisionShape2D = $Area2D/VerticalCollisionShape
@onready var area_2d : Area2D = $Area2D
@onready var particule : CPUParticles2D = $CPUParticles2D


@export var speed_1 : float = 6.0
@export var speed_2 : float = 10.0

var actual_speed : float
var actual_direction : Vector2 = Vector2.ZERO

var orders : Dictionary = {
	"NO" : Vector2.ZERO,
	"TN" : Vector2.UP,
	"TE" : Vector2.RIGHT,
	"TS" : Vector2.DOWN,
	"TW" : Vector2.LEFT
}

func _ready():
	if str(name) == "Boat":
		name = "A"
	var aftername : String = MorseGlobal.letters.find_key(str(name))
	id_node.text = name + aftername
	area_2d.area_entered.connect(on_area_entered)
	area_2d.area_exited.connect(on_area_exited)

func _physics_process(delta):
	position += actual_direction * (delta * actual_speed)

func on_order_received(new_order):
	if new_order in orders :
		if actual_direction == orders[new_order] :
			actual_speed = speed_2
		else :
			actual_direction = orders[new_order]
			actual_speed = speed_1
		# Collision and particules
		if actual_direction == Vector2.ZERO :
			particule.emitting = false
			# Keep actual collision
		elif actual_direction.x != 0 :
			particule.emitting = true
			horizontal_collision_shape.disabled = true
			vertical_collision_shape.disabled = false
		else :
			particule.emitting = true
			horizontal_collision_shape.disabled = false
			vertical_collision_shape.disabled = true
		# Animation
		if new_order in sprite.sprite_frames.get_animation_names() :
			sprite.play(new_order)

func on_area_exited(_area : Area2D):
	pass

func on_area_entered(area : Area2D):
	if area.get_parent() is Boat :
		var old_direction = actual_direction
		actual_direction = Vector2.ZERO
		position -= old_direction * 2
	elif area.get_parent() is Rock :
		var old_direction = actual_direction
		actual_direction = Vector2.ZERO
		position -= old_direction * 2
