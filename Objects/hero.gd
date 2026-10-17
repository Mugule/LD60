extends Node

@onready var letters_container = $LetterContainer
@onready var biper = $Biper

signal valid_word(word:String)

func _ready():
	biper.bip.connect(letters_container.add_bip)
	letters_container.valid_word.connect(on_valid_word)

func on_valid_word(word : String):
	print('valid word %s' % word)
	#letters_container.reset_all()
	valid_word.emit(word)
	
	# waiting for next
