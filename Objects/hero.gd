extends Node

@onready var letters_container = $LetterContainer
@onready var biper : Button = $Biper
@onready var tw = $TW

signal valid_word(word:String)

func _ready():
	biper.mouse_entered.connect(tw.outline_on)
	biper.mouse_exited.connect(tw.outline_off)
	biper.ti.connect(letters_container.ti)
	biper.ti.connect(tw.clicked)
	biper.tah.connect(letters_container.tah)
	biper.bip_end.connect(letters_container.bip_end)
	biper.bip_end.connect(tw.unclicked)
	letters_container.valid_word.connect(on_valid_word)

func on_valid_word(word : String):
	print('valid word %s' % word)
	#letters_container.reset_all()
	valid_word.emit(word)
	
	# waiting for next
