extends Node

@onready var game_manager: Node2D = %GameManager

func save_game():
	
	print("save_game()")
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var save_dict = {
		"record_5_levels" : game_manager.record_to_save
	}
	
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)

func load_game():
	
	print("load_game()")
	
	if not FileAccess.file_exists("user://savegame.save"):
		print("No save to load!")
		return

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var saved_data = json.data
		
		# Print save data for debugging purposes
		print(saved_data)
		
		game_manager.current_record = saved_data.record_5_levels
