extends Node2D

const number_lines = 99

func get_random_word():
	print("get_random_word()")
	
	var file = FileAccess.open("res://possible_words.txt", FileAccess.READ)
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randf_range(1, number_lines)
	var random_word = ""
	
	for n in range(random_number):
		random_word = file.get_line()
		print(random_word)
	
	return random_word.to_upper()
