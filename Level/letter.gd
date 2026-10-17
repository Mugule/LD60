class_name NodeLetter extends TextureRect

@onready var letter_node : RichTextLabel = $Letter
@onready var bips : HBoxContainer = $Bips
@onready var timer : Timer = $Timer
@onready var timer_bar : ColorRect = $TimerBar
@onready var checkmark : TextureRect = $Checkmark

var active : bool = false

var index : int = 0
var current : String
var result : String = ""

signal wrong()
signal valid(letter:String)

func _ready():
	timer.timeout.connect(on_timer_end)
	reset()

func _process(_delta):
	if active : # Bar go down
		var ratio : float = timer.time_left / MorseGlobal.space_time
		timer_bar.size.x = ratio * 26

func reset():
	active = false
	timer.wait_time = MorseGlobal.space_time
	letter_node.text = ""
	current = ""
	timer_bar.size.x = 26
	for b in bips.get_children() :
		b.hide()
	checkmark.hide()

func add_bip(bip : String):
	# (re)start timer
	start_timer()
	# Show titah
	current += bip
	if bip == "." :
		bips.get_node("Ti"+str(index)).show()
	elif bip == "-" :
		bips.get_node("Ta"+str(index)).show()
	# Increment
	index += 1
	# PRESHOW LETTER
	if MorseGlobal.letters.has(current) :
		result = MorseGlobal.letters[current]
	else :
		result = "?"
	letter_node.text = result
	# IF FULL CHECK
	if index == 4 :
		check()

func start_timer():
	active = true
	timer.start()

func on_timer_end():
	check()

func check():
	active = false
	timer.stop()
	if result == "?" :
		wrong.emit()
	else :
		checkmark.show()
		valid.emit(result)
