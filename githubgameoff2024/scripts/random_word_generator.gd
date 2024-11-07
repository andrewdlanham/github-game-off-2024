extends Node2D

const number_lines = 99

var file

func _ready() -> void:
	file = FileAccess.open("res://possible_words.txt", FileAccess.READ)

func get_random_word():
	print("get_random_word()")
	
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randf_range(1, number_lines)
	var random_word = ""
	
	for n in range(random_number):
		random_word = file.get_line()
	
	return random_word.to_upper()
