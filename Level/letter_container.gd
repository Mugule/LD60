extends Control

const POOL_L_1 : Array[String] = ["M","A","U","D","I","T"] # means "cursed" in fr
const POOL_L_2 : Array[String] = ["N","E","W","S","O"] # means nothing to me

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

func ti():
	if actual_index == 2 :
		reset_all()
	if can_take_order :
		actual_letter.ti()

func tah():
	if can_take_order :
		actual_letter.tah()

func bip_end():
	if can_take_order :
		actual_letter.bip_end()

func on_letter_valid(letter : String):
	can_take_order = false # Parent will reset it
	if actual_letter : # I don't understand how but sometimes this is null
		print("received_letter : %s - %s" % [actual_letter.name,letter])
		var pool = POOL_L_1
		if actual_index == 1 :
			pool = POOL_L_2
		if letter in pool :
			actual_word += letter
			actual_index += 1
			if actual_index >= letter_nodes.size() : # VALID ORDER <=
				actual_letter = null
				valid_word.emit(actual_word)
			else :
				actual_letter = get_child(actual_index)
				can_take_order = true
		else :
			on_letter_wrong()

func on_letter_wrong():
	reset_all()
