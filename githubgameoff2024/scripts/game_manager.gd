extends Node

# Variables
@onready var random_word_generator: Node2D = %RandomWordGenerator
@onready var timer_manager: Node = %TimerManager
@onready var secret_word_label: Label = %SecretWordLabel
@onready var player: CharacterBody2D = %Player
@onready var countdown_timer: Label = %CountdownTimer
@onready var letters: Node = %Letters
@onready var save_game: Node = %SaveGame
@onready var level_manager: Node = %LevelManager

var secret_word

var record_to_save
var current_record	

func _ready() -> void:
	start_game()
	
func start_game():
	#save_game.load_game()
	level_manager.prepare_first_level()
	
func end_game():
	print("end_game()")
	#record_to_save = round(timer_manager.elapsed_time * 100) / 100
	save_game.save_game()
