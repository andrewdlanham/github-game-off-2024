extends Node2D

@onready var random_word_generator: Node2D = %RandomWordGenerator
@onready var timer_manager: Node = %TimerManager
@onready var secret_word_label: Label = %SecretWordLabel
@onready var player: CharacterBody2D = %Player

var secret_word
var spawn_points
var available_spawn_points
var level_paths = ["res://levels/level_1.tscn",
					"res://levels/level_2.tscn"
					]

var level_set = level_paths # TODO: Change to random level set
var level_set_idx
var current_level
var current_level_instance
var is_level_complete: bool

var letter_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	level_set_idx = -1
	
	letter_item = load("res://scenes/letter_item.tscn")
	
	if not letter_item:
		print("ERROR: letter_item didn't load properly")
		get_tree().quit()
	
	load_next_level()
	setup_level()
	timer_manager.unpause_timer()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Check if player has revealed the secret word
	if secret_word_label.text == secret_word && !is_level_complete:
		print("LEVEL COMPLETE")
		is_level_complete = true
		timer_manager.pause_timer()
		secret_word_label.add_theme_color_override("font_color", Color(0, 1, 0))
		await get_tree().create_timer(3.0).timeout
		load_next_level()
		setup_level()
		
func check_for_correct_guess(guess):
	print("Checking if guess is correct...")
	if guess.to_upper() == secret_word:
		print("Correct guess!")
		secret_word_label.text = secret_word
		

func load_next_level():
	print("Loading next level...")
	
	if current_level_instance:
		current_level_instance.queue_free()
	
	level_set_idx += 1
	
	current_level = load(level_set[level_set_idx])
	current_level_instance = current_level.instantiate()
	add_child(current_level_instance) # TODO: Add to correct place in scene
	
func setup_level():
	
	var letters = %Letters
	
	# Despawn letter items
	for child in letters.get_children():
		child.queue_free()
	
	# Get secret word
	secret_word = random_word_generator.get_random_word()
	print("secret word: " + secret_word)
	
	# Set up word label
	secret_word_label.text = ""
	for n in range (secret_word.length()): secret_word_label.text += "-"
	
	# Set is_level_complete here
	is_level_complete = false
	
	# Select letter item spawn points
	available_spawn_points = []
	available_spawn_points = get_tree().get_nodes_in_group("Spawn Points")
	print("# of available spawn points: " + str(available_spawn_points.size()))
	spawn_points = []
	for n in range(secret_word.length()):
		var random_spawn_point = available_spawn_points[randi_range(0, available_spawn_points.size() - 1)]
		spawn_points.append(random_spawn_point)
		available_spawn_points.erase(random_spawn_point)
	
	print("# of selected spawn points: " + str(spawn_points.size()))
	
	# Spawn letter items
	for n in range(secret_word.length()):
		var letter_item_instance = letter_item.instantiate()
		letter_item_instance.secret_word_label = secret_word_label
		letter_item_instance.letterPosition = n
		letter_item_instance.hiddenLetter = secret_word[n]
		letter_item_instance.position = spawn_points[n].position
		letters.add_child(letter_item_instance)
