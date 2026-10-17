extends HBoxContainer

var letter_nodes : Array
var actual_letter : NodeLetter
var actual_word : String
var actual_index : int

var can_take_order : bool = true

signal valid_word(word : String)

func _ready():
	for l in get_children():
		if l is NodeLetter :
			letter_nodes.append(l)
			l.valid.connect(on_letter_valid)
			l.wrong.connect(on_letter_wrong)
	reset_all()

func reset_all(take_order_after_reset : bool = true):
	print("reset letters")
	can_take_order = false
	for l in letter_nodes :
		l.reset()
	actual_index = 0
	actual_letter = get_child(actual_index)
	actual_word = ''
	can_take_order = take_order_after_reset

func add_bip(bip : String) :
	if can_take_order :
		actual_letter.add_bip(bip)

func on_letter_valid(letter : String):
	can_take_order = false # Parent will reset it
	print("actual_letter : %s - %s" % [actual_letter.name,letter])
	actual_word += letter
	actual_index += 1
	if actual_index >= letter_nodes.size() : # VALID ORDER <=
		actual_letter = null
		valid_word.emit(actual_word)
	else :
		actual_letter = get_child(actual_index)
		can_take_order = true

func on_letter_wrong():
	reset_all()
