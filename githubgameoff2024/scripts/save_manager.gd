extends Node

var selected_num_levels

func save_game(new_record, num_levels, reset_all_records):
	
	print("save_game()")
	
	var old_save_data = load_game()
	if reset_all_records == true: old_save_data = null
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var save_dict
	if old_save_data == null:
		print("Initializing first time records...")
		save_dict = {
			"record_5_levels"  : -1,
			"record_15_levels" : -1,
			"record_25_levels" : -1
		}
	elif num_levels == 5:
		save_dict = {
			"record_5_levels"  : new_record,
			"record_15_levels" : old_save_data.record_15_levels,
			"record_25_levels" : old_save_data.record_25_levels
		}
	elif num_levels == 15:
		save_dict = {
			"record_5_levels"  : old_save_data.record_5_levels,
			"record_15_levels" : new_record,
			"record_25_levels" : old_save_data.record_25_levels
		}
	else: 
		save_dict = {
			"record_5_levels"  : old_save_data.record_5_levels,
			"record_15_levels" : old_save_data.record_15_levels,
			"record_25_levels" : new_record
		}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	
	print("Data saved: " + json_string)

func load_game():
	
	print("load_game()")
	
	if not FileAccess.file_exists("user://savegame.save"):
		print("No save to load!")
		return null

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var saved_data
	print("Save file length: " + str(save_file.get_length()))
	
	if save_file.get_length() == 0:
		return {"record_5_levels"  : 999,
				"record_15_levels" : 999,
				"record_25_levels" : 999}
	
	while save_file.get_position() < save_file.get_length():
		print("Reading save data...")
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		saved_data = json.data
		
		# Print save data for debugging purposes
		print("Player's save data:")
		print(saved_data)
		
	print("Returning save data...")
	return saved_data
