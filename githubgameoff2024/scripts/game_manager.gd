extends Node

# Variables

@onready var save_game: Node = %SaveGame
@onready var level_manager: Node = %LevelManager

var num_levels = 5 # TODO: Set this depending on menu option selected
var old_record

func _ready() -> void:
	start_game()
	
func start_game():
	var old_save_data = save_game.load_game()
	if num_levels == 5:
		old_record = old_save_data.record_5_levels
	
	print("OLD RECORD: " + str(old_record))
	level_manager.prepare_first_level()
	
func end_game(end_time):
	print("end_game()")
	#record_to_save = round(timer_manager.elapsed_time * 100) / 100
	save_game.save_game(end_time, num_levels)
	
	await get_tree().create_timer(2).timeout
	get_tree().quit()
