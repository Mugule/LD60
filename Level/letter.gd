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
		timer_bar.size.x = ratio * 28

func reset(): # Parent reset the letter
	active = false
	index = 0
	timer.wait_time = MorseGlobal.space_time
	letter_node.text = "-"
	current = ""
	timer_bar.size.x = 28
	for b in bips.get_children() :
		b.hide()
	checkmark.hide()

func ti():
	current += "."
	bips.get_node("Ti"+str(index)).show()
	update_letter()

func tah():
	if current.length() > 0 :
		current[-1] = "-"
		bips.get_node("Ti"+str(index)).hide()
		bips.get_node("Ta"+str(index)).show()
		update_letter()

func update_letter():
	if MorseGlobal.letters.has(current) :
		result = MorseGlobal.letters[current]
	else :
		result = "?"
	letter_node.text = result

func bip_end():
	timer.stop()
	index += 1
	if index == 4 :
		check()
	if bips.get_node("Ti0").visible or bips.get_node("Ta0").visible : # Sry about this
		start_timer()

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
