extends Node2D

# Variables
@onready var random_word_generator: Node2D = %RandomWordGenerator
@onready var timer_manager: Node = %TimerManager
@onready var secret_word_label: Label = %SecretWordLabel
@onready var player: CharacterBody2D = %Player
@onready var countdown_timer: Label = %CountdownTimer
@onready var letters: Node = %Letters
@onready var save_game: Node = %SaveGame

@onready var letter_item = load("res://scenes/letter_item.tscn")

var spawn_points
var available_spawn_points
var level_paths = ["res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn"
					]

var level_set
@onready var level_set_idx = -1
var current_level
var current_level_instance
var is_level_complete: bool

var secret_word

var record_to_save
var current_record

func _ready() -> void:
	
	if not letter_item:
		print("ERROR: letter_item didn't load properly")
		get_tree().quit()
	
	save_game.load_game()
	level_set = level_paths		# TODO: Randomize level_set
	
	cleanup_level_end()
	load_next_level()
	setup_level()
	
func _process(_delta: float) -> void:
	
	# Check if player has revealed the secret word
	if secret_word_label.text == secret_word && !is_level_complete:
		print("LEVEL COMPLETE")
		handle_level_transition()
		
func check_for_correct_guess(guess):
	print("Checking if guess is correct...")
	if guess.to_upper() == secret_word:
		print("Correct guess!")
		secret_word_label.text = secret_word
		
func handle_level_transition():
	
	# TODO: Update the record logic
	timer_manager.pause_timer()
	record_to_save = timer_manager.elapsed_time
	save_game.save_game()
	
	secret_word_label.add_theme_color_override("font_color", Color(0, 1, 0))
	is_level_complete = true
	player.disable_movement()
	player.disable_collision()
	
	await get_tree().create_timer(2).timeout # Let the player process that they beat the level
	cleanup_level_end()
	load_next_level()
	await get_tree().create_timer(0.1).timeout
	setup_level()
	
	# Countdown timer
	countdown_timer.text = '3'
	countdown_timer.visible = true
	
	await get_tree().create_timer(1.0).timeout
	countdown_timer.text = '2'
	await get_tree().create_timer(1.0).timeout
	countdown_timer.text = '1'
	await get_tree().create_timer(1.0).timeout
	countdown_timer.visible = false
	#
	
	timer_manager.unpause_timer()
	is_level_complete = false
	player.enable_movement()
	player.enable_collision()

func load_next_level():
	
	if current_level_instance:
		print("Unloading current level...")
		current_level_instance.queue_free()
	
	level_set_idx += 1
	
	print("Loading next level...")
	current_level = load(level_set[level_set_idx])
	current_level_instance = current_level.instantiate()
	add_child(current_level_instance) # TODO: Update where I add the level in the tree
	
func setup_level():
	print("setup_level()")
	
	# Move player to spawn point
	var player_spawn_point = get_tree().get_nodes_in_group("PlayerSpawnPoint")
	player.position = player_spawn_point[0].position
	
	# Select letter item spawn points
	available_spawn_points = []
	available_spawn_points = get_tree().get_nodes_in_group("LetterSpawnPoint")
	print("# of spawn points: " + str(available_spawn_points.size()))
	spawn_points = []
	for n in range(secret_word.length()):
		var random_spawn_point = available_spawn_points[randi_range(0, available_spawn_points.size() - 1)]
		spawn_points.append(random_spawn_point)
		available_spawn_points.erase(random_spawn_point)
	print("# of spawn points used: " + str(spawn_points.size()))
	
	# Spawn letter items
	for n in range(secret_word.length()):
		var letter_item_instance = letter_item.instantiate()
		letter_item_instance.secret_word_label = secret_word_label
		letter_item_instance.letterPosition = n
		letter_item_instance.hiddenLetter = secret_word[n]
		letter_item_instance.position = spawn_points[n].position
		letters.add_child(letter_item_instance)
	
func cleanup_level_end():
	
	secret_word_label.add_theme_color_override("font_color", Color(1, 1, 1))
	
	# Get next secret word
	secret_word = random_word_generator.get_random_word()
	print("secret word: " + secret_word)
	
	# Set up word label
	secret_word_label.text = ""
	for n in range (secret_word.length()): secret_word_label.text += "-"
	
	# Despawn extra letter items from previous level
	for child in letters.get_children():
		child.queue_free()
