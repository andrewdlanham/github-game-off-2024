extends Node2D

@onready var random_word_generator: Node2D = %RandomWordGenerator

var random_word

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("_ready()")
	
	# Get random word for this round
	var random_word = random_word_generator.get_random_word()
	print("random word: " + random_word)
	
	# TODO: Set up letters to be collected
	
	# TODO: Start timer when player gets control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
