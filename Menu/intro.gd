extends Control

@onready var next_button : Button = $Next
@onready var panels : Control = $Panels
var p_index : int = 1
var l_index : int = 0

func _ready():
	next_button.pressed.connect(next)

func next():
	var actual_p = panels.get_node(str(p_index))
	if actual_p.has_node("Label"+str(l_index+1)):
		if l_index != 0 :
			actual_p.get_node("Label"+str(l_index)).hide()
		var l = actual_p.get_node("Label"+str(l_index+1))
		l.show()
		l_index += 1
	else : # NO MORE LABEL
		if panels.has_node(str(p_index+1)) :
			actual_p.hide()
			panels.get_node(str(p_index+1)).show()
			l_index = 0
			p_index += 1
		else : # NO MORE PANEL
			ResourceLoader.load_threaded_request("res://Level/level.tscn")
			var packed_scene = ResourceLoader.load_threaded_get("res://Level/level.tscn")
			get_tree().change_scene_to_packed(packed_scene)
