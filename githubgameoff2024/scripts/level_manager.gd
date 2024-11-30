extends Node

@onready var countdown_timer: Label = %CountdownTimer
@onready var timer_manager: Node = %TimerManager
@onready var guess_manager: Node = %GuessManager
@onready var secret_word_label: Label = %SecretWordLabel
@onready var player: CharacterBody2D = %Player
@onready var letter_item = load("res://scenes/letter_item.tscn")
@onready var letters: Node = %Letters
@onready var random_word_generator: Node2D = %RandomWordGenerator
@onready var sound_manager: Node = get_node("/root/Game/SoundManager")
@onready var game_manager: Node = %GameManager
@onready var save_manager: Node = get_node("/root/Game/SaveManager")

@onready var level_number_label: Label = %LevelNumberLabel


var secret_word
var level_paths = ["res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_1.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn",
					"res://levels/level_2.tscn"
					]

var level_set = []
@onready var level_set_idx = -1
var current_level
var current_level_instance
var is_level_complete: bool = false
var spawn_points
var available_spawn_points


func freeze_level():
	print("freeze_level()")
	timer_manager.pause_timer()
	player.disable_movement()
	player.disable_collision()
	guess_manager.set_process(false)
	guess_manager.exit_guessing_mode()

func unfreeze_level():
	print("unfreeze_level()")
	timer_manager.unpause_timer()
	player.enable_movement()
	player.enable_collision()
	guess_manager.set_process(true)

func check_for_level_end(guess):
	print("check_for_level_end()")
	if guess != null && guess.to_upper() == secret_word:
		print("Correct guess!")
		secret_word_label.text = secret_word
		level_number_label.text = str(level_set_idx + 1) + "/" + str(save_manager.selected_num_levels)
		
	# Check if player has revealed the secret word
	if secret_word_label.text == secret_word && !is_level_complete:
		print("LEVEL COMPLETE")
		is_level_complete = true
		sound_manager.guess_correct_sound.play()
		secret_word_label.add_theme_color_override("font_color", Color(0, 1, 0))
		
		freeze_level()
		
		if level_set_idx == level_set.size() - 1:
			print("FINAL LEVEL")
			await game_manager.end_game(timer_manager.elapsed_time)
			print("THIS SHOULD NOT PRINT")
			return
		
		await get_tree().create_timer(2).timeout # Let the player process that they beat the level
		await handle_level_transition()
		is_level_complete = false
		unfreeze_level()


func prepare_first_level():
	print("prepare_first_level()")
	await get_tree().create_timer(0.1).timeout
	level_number_label.text = "0" + "/" + str(save_manager.selected_num_levels)
	await get_tree().create_timer(0.1).timeout
	
	# Randomize level set
	for n in range(save_manager.selected_num_levels):
		var random_level = level_paths[randi_range(0, level_paths.size() - 1)]
		level_set.append(random_level)
		level_paths.erase(random_level)
	
	#
	freeze_level()
	await handle_level_transition()
	unfreeze_level()

func handle_level_transition():
	print("handle_level_transition()")
	cleanup_level_end()
	unload_current_level()
	load_next_level()
	prepare_level()
	print("line after prepare_level() --------------------")
	
	# Countdown timer
	# TODO: Update timer values once done testing
	countdown_timer.visible = true
	countdown_timer.text = '3'
	sound_manager.timer_tick_sound.play()
	await get_tree().create_timer(0.2).timeout
	countdown_timer.text = '2'
	sound_manager.timer_tick_sound.play()
	await get_tree().create_timer(0.2).timeout
	countdown_timer.text = '1'
	sound_manager.timer_tick_sound.play()
	await get_tree().create_timer(0.2).timeout
	sound_manager.timer_go_sound.play()
	countdown_timer.visible = false
	
func unload_current_level():
	print("unload_current_level()")
	if current_level_instance:
		print("Unloading current level...")
		current_level_instance.queue_free()

func load_next_level():
	
	level_set_idx += 1
	print("Loading level...")
	current_level = load(level_set[level_set_idx])
	current_level_instance = current_level.instantiate()
	add_child(current_level_instance) # TODO: Update where I add the level in the tree
	
func prepare_level():
	print("prepare_level()")
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
	print("cleanup_level_end()")
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
