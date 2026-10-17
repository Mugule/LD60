extends Node

@onready var letters_container = $LetterContainer
@onready var biper = $Biper

signal valid_word(word:String)

func _ready():
	biper.ti.connect(letters_container.ti)
	biper.tah.connect(letters_container.tah)
	biper.bip_end.connect(letters_container.bip_end)
	letters_container.valid_word.connect(on_valid_word)

func on_valid_word(word : String):
	print('valid word %s' % word)
	#letters_container.reset_all()
	valid_word.emit(word)
	
	# waiting for next
