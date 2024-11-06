extends Node2D

@onready var random_word_generator: Node2D = %RandomWordGenerator

var random_word

var spawn_points = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("_ready()")
	
	# Get random word for this round
	random_word = random_word_generator.get_random_word()
	print("random word: " + random_word)
	
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
	var letter_item = preload("res://scenes/letter_item.tscn")
	for n in range(random_word.length()):
		var letter_item_instance = letter_item.instantiate()
		letter_item_instance.hiddenLetter = random_word[n]
		letter_item_instance.position = spawn_points[n].position
		# TODO: Add these to the right spot in the tree
		add_child(letter_item_instance)
	
	
	# TODO: Start timer when player gets control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
