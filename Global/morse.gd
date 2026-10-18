class_name Morse extends Node

# I put this in Global to be acceded when I want. There is the morse and the 
# setting of the short and space time

@export var short_time : float = 0.1
@export var space_time : float = 0.6

var letters : Dictionary = {
	".-" : "A",
	"-..." : "B",
	"-.-." : "C",
	"-.." : "D",
	"." : "E",
	"..-." : "F",
	"--." : "G",
	"...." : "H",
	".." : "I",
	".---" : "J",
	"-.-" : "K",
	".-.." : "L",
	"--" : "M",
	"-." : "N",
	"---" : "O",
	".--.": "P",
	"--.-": "Q",
	".-." : "R",
	"..." : "S",
	"-" : "T",
	"..-" : "U",
	"...-" : "V",
	".--" : "W",
	"-..-" : "X",
	"-.--" : "Y",
	"--.." : "Z"
	}
