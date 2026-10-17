extends Label

@onready var bar : ColorRect = $TimerBar

var drones 

func _physics_process(_delta):
	if drones :
		var ratio : float = drones.timer_left / drones.timer_max
		bar.size.x = int(ratio * 200.0)
		bar.position.x = 180.0 - bar.size.x / 2.0
