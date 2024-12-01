extends Node

# Variables

@onready var save_manager: Node = get_node("/root/Game/SaveManager")
@onready var level_manager: Node = %LevelManager
@onready var sound_manager: Node = get_node("/root/Game/SoundManager")


var old_record

func _ready() -> void:
	sound_manager.menu_music.stop()
	start_game()
	
func start_game():
	
	sound_manager.gameplay_music.play()
	var old_save_data = save_manager.load_game()
	
	# Set old record to beat
	match save_manager.selected_num_levels:
		3:	old_record = old_save_data.record_3_levels
		5:	old_record = old_save_data.record_5_levels
		10: old_record = old_save_data.record_10_levels
	
	print("OLD RECORD: " + str(old_record))
	level_manager.prepare_first_level()
	
func end_game(end_time):
	print("end_game()")
	
	var new_record = round(end_time * 100) / 100
	if old_record == -1 || new_record < old_record:
		print('SAVING NEW RECORD!')
		save_manager.save_game(new_record, save_manager.selected_num_levels, false)
	
	await get_tree().create_timer(2).timeout
	get_tree().quit()
