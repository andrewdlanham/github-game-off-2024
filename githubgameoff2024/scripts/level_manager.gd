extends Node

@onready var countdown_timer: Label = %CountdownTimer
@onready var timer_manager: Node = %TimerManager
@onready var guess_manager: Node = %GuessManager

@onready var secret_word_label: Label = %SecretWordLabel
@onready var player: CharacterBody2D = %Player

@onready var letter_item = load("res://scenes/letter_item.tscn")
@onready var letters: Node = %Letters
@onready var random_word_generator: Node2D = %RandomWordGenerator

var secret_word

var level_paths = ["res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn"
					]

var level_set = []
@onready var level_set_idx = -1
var num_levels
var current_level
var current_level_instance
var is_level_complete: bool
var spawn_points
var available_spawn_points

func _process(_delta: float) -> void:
	
	# Check if player has revealed the secret word
	if secret_word_label.text == secret_word && !is_level_complete:
		#print("LEVEL COMPLETE")
		secret_word_label.add_theme_color_override("font_color", Color(0, 1, 0))
		freeze_level()
		await get_tree().create_timer(2).timeout # Let the player process that they beat the level
		handle_level_transition()
		unfreeze_level()

func freeze_level():
	is_level_complete = true
	timer_manager.pause_timer()
	player.disable_movement()
	player.disable_collision()
	guess_manager.set_process(false)
	guess_manager.exit_guessing_mode

func unfreeze_level():
	is_level_complete = false
	timer_manager.unpause_timer()
	player.enable_movement()
	player.enable_collision()
	guess_manager.set_process(true)

func check_for_correct_guess(guess):
	print("Checking if guess is correct...")
	if guess.to_upper() == secret_word:
		print("Correct guess!")
		secret_word_label.text = secret_word


func prepare_first_level():
	print("prepare_first_level()")
	#num_levels = selected_num_levels
	await get_tree().create_timer(0.2).timeout
	
	# Randomize level set
	for n in range(level_paths.size()):
		var random_level = level_paths[randi_range(0, level_paths.size() - 1)]
		level_set.append(random_level)
		level_paths.erase(random_level)
	
	#
	freeze_level()
	await handle_level_transition()
	unfreeze_level()

func handle_level_transition():
	
	cleanup_level_end()
	load_next_level()
	await get_tree().create_timer(0.1).timeout
	prepare_level()
	
	# Countdown timer
	countdown_timer.text = '3'
	countdown_timer.visible = true
	
	await get_tree().create_timer(1.0).timeout
	countdown_timer.text = '2'
	await get_tree().create_timer(1.0).timeout
	countdown_timer.text = '1'
	await get_tree().create_timer(1.0).timeout
	countdown_timer.visible = false

func load_next_level():
	
	if current_level_instance:
		print("Unloading current level...")
		current_level_instance.queue_free()
	
	level_set_idx += 1
	
	print("Loading level...")
	current_level = load(level_set[level_set_idx])
	current_level_instance = current_level.instantiate()
	add_child(current_level_instance) # TODO: Update where I add the level in the tree
	
func prepare_level():
	print("setup_level()")
	player.move_to_spawn()
	set_up_secret_word()
	
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
	
	# Despawn extra letter items from previous level
	for child in letters.get_children():
		child.queue_free()
		
func set_up_secret_word():
	# Get next secret word
	secret_word = random_word_generator.get_random_word()
	print("secret word: " + secret_word)
	
	# Set up word label
	secret_word_label.text = ""
	for n in range (secret_word.length()): secret_word_label.text += "-"