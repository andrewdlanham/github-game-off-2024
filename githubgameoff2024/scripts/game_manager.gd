extends Node2D

@onready var random_word_generator: Node2D = %RandomWordGenerator
@onready var timer_manager: Node = %TimerManager
@onready var secret_word_label: Label = %SecretWordLabel
@onready var player: CharacterBody2D = %Player

var secret_word
var spawn_points = []
var level_paths = ["res://levels/level_1.tscn",
					"res://levels/level_2.tscn"
					]

var level_set = level_paths # TODO: Change to random level set
var level_set_idx = -1
var current_level
var current_level_instance
var is_level_complete: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	is_level_complete = false
	
	# Load level
	load_next_level()
	
	#
	secret_word = random_word_generator.get_random_word()	# Get random word for this round
	print("random word: " + secret_word)
	
	# Populate revelead word with dashes
	for n in range (secret_word.length()): secret_word_label.text += "-"
	
	# Get all possible spawn points in the level
	
	var available_spawn_points
	available_spawn_points = get_tree().get_nodes_in_group("Spawn Points")
	print("Available spawn points: " + str(available_spawn_points.size()))
	
	# Select number of spawn points equal to number of letters in random word
	for n in range(secret_word.length()):
		var random_spawn_point = available_spawn_points[randi_range(0, available_spawn_points.size() - 1)]
		spawn_points.append(random_spawn_point)
		available_spawn_points.erase(random_spawn_point)
	
	# Spawn letters to be collected at selected spawn points
	var letter_item = load("res://scenes/letter_item.tscn")
	
	if not letter_item:
		print("ERROR: letter_item didn't load properly")
	
	print("# of spawn points: " + str(spawn_points.size()))
	
	for n in range(secret_word.length()):
		var letter_item_instance = letter_item.instantiate()
		letter_item_instance.secret_word_label = secret_word_label
		letter_item_instance.letterPosition = n
		letter_item_instance.hiddenLetter = secret_word[n]
		letter_item_instance.position = spawn_points[n].position
		add_child(letter_item_instance) # TODO: Add these to the right spot in the tree
	
	# Start timer
	timer_manager.unpause_timer()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Check if player has revealed the secret word
	if secret_word_label.text == secret_word && !is_level_complete:
		print("LEVEL COMPLETE")
		is_level_complete = true
		timer_manager.pause_timer()
		secret_word_label.add_theme_color_override("font_color", Color(0, 1, 0))
		
func check_for_correct_guess(guess):
	print("Checking if guess is correct...")
	if guess.to_upper() == secret_word:
		print("Correct guess!")
		secret_word_label.text = secret_word
		# TODO: Despawn remaining letter items
		

func load_next_level():
	print("Loading next level...")
	
	if current_level_instance:
		current_level_instance.queue_free()
	
	level_set_idx += 1
	
	current_level = load(level_set[level_set_idx])
	current_level_instance = current_level.instantiate()
	add_child(current_level_instance) # TODO: Add to correct place in scene
	
