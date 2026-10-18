class_name Drone extends Node2D

@onready var area_2d : Area2D = $Area2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var target : Boat

var attacking : bool = true 
var blocked : bool = false

@export var speed : float = 30
var target_pos : Vector2 = Vector2.ZERO
var origin_spawn : Vector2 = Vector2(0,300)
var hp : int = 2

signal attack(attacked : Boat)
signal drone_dead

func _ready():
	area_2d.area_entered.connect(on_area_entered)

# OMG dont look this infernal IF
func _physics_process(delta):
	if !blocked :
		if attacking :
			if target :
				if target is Boat :
					target_pos = target.global_position
			else :
				target_pos = origin_spawn
		var direction : Vector2 = position.direction_to(target_pos)
		if direction.x > 0.5 : 
			sprite.play("side")
			sprite.flip_h = true
		elif direction.x < -0.5 : 
			sprite.play("side")
			sprite.flip_h = false
		elif direction.y > 0 :
			sprite.play("down")
		else :
			sprite.play("up")
		position += direction * (delta * speed)

func on_area_entered(area : Area2D):
	if area.get_parent() == target :
		await get_tree().create_timer(0.4).timeout
		if !target.safe :
			attacking = false
			target_pos = origin_spawn
			attack.emit(target)

func shooted():
	hp -= 1 
	if hp == 0 : # Dead
		Sound.play("drone_dead")
		drone_dead.emit()
		blocked = true
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()
