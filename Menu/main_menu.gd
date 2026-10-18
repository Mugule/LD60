extends Control

@onready var play_button : Button = $TitleScreen/Play
@onready var next_button : Button = $Intro/Next
@onready var title_screen : Control = $TitleScreen
@onready var intro : Control = $Intro

func _ready():
	play_button.pressed.connect(on_play)
	play_button.grab_focus()

func on_play():
	title_screen.hide()
	intro.show()
	next_button.grab_focus()
