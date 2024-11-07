extends Node2D

@onready var random_word_generator: Node2D = %RandomWordGenerator
@onready var secret_word_label: Label = %SecretWordLabel

@onready var player: CharacterBody2D = %Player


var random_word
var revealed_word = ""

var spawn_points = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	random_word = random_word_generator.get_random_word()	# Get random word for this round
	print("random word: " + random_word)
	
	# Populate revelead word with dashes
	for n in range (random_word.length()): revealed_word += "-"
	secret_word_label.text = revealed_word
	
	# Get all possible spawn points in the level
	
	var available_spawn_points
	available_spawn_points = get_tree().get_nodes_in_group("Spawn Points")
	print("Available spawn points: " + str(available_spawn_points.size()))
	
	# Select number of spawn points equal to number of letters in random word
	for n in range(random_word.length()):
		var random_spawn_point = available_spawn_points[randi_range(0, available_spawn_points.size() - 1)]
		spawn_points.append(random_spawn_point)
		available_spawn_points.erase(random_spawn_point)
	
	# Spawn letters to be collected at selected spawn points
	var letter_item = load("res://scenes/letter_item.tscn")
	
	if not letter_item:
		print("ERROR: letter_item didn't load properly")
	
	print("#spawn points: " + str(spawn_points.size()))
	
	for n in range(random_word.length()):
		var letter_item_instance = letter_item.instantiate()
		letter_item_instance.secret_word_label = secret_word_label
		letter_item_instance.letterPosition = n
		letter_item_instance.hiddenLetter = random_word[n]
		letter_item_instance.position = spawn_points[n].position
		add_child(letter_item_instance) # TODO: Add these to the right spot in the tree
	
	
	# TODO: Start timer when player gets control
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_for_correct_guess(guess):
	print("Checking if guess is correct...")
	if guess.to_upper() == random_word:
		print("Correct guess!")
