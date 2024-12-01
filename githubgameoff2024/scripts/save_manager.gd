extends Node

var selected_num_levels
var is_on_menu

func save_game(new_record, num_levels, reset_all_records, old_save_data):
	
	print("save_game(" + str(new_record) + ", " + str(num_levels) + ")")
	var first_time = false
	
	if not FileAccess.file_exists("user://savegame.save"):
		print("No save file! Initializing default records...")
		first_time = true
		
	var save_dict
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string
	
	if num_levels == 0 && !first_time:
		save_dict = {
			"record_3_levels"  : old_save_data.record_3_levels,
			"record_5_levels" : old_save_data.record_5_levels,
			"record_10_levels" : old_save_data.record_10_levels
		}
		json_string = JSON.stringify(save_dict)
		save_file.store_line(json_string)
	
		print("Default records saved: " + json_string)
		
		return
	
	
	if first_time || old_save_data == null: 
		save_dict = {
			"record_3_levels"  : -1,
			"record_5_levels" : -1,
			"record_10_levels" : -1
		}
		json_string = JSON.stringify(save_dict)
		save_file.store_line(json_string)
	
		print("Default records saved: " + json_string)
		
		return
	
	if reset_all_records == true:
		print("Initializing first time records...")
		save_dict = {
			"record_3_levels"  : -1,
			"record_5_levels" : -1,
			"record_10_levels" : -1
		}
	elif num_levels == 3:
		save_dict = {
			"record_3_levels"  : new_record,
			"record_5_levels" : old_save_data.record_5_levels,
			"record_10_levels" : old_save_data.record_10_levels
		}
	elif num_levels == 5:
		save_dict = {
			"record_3_levels"  : old_save_data.record_3_levels,
			"record_5_levels" : new_record,
			"record_10_levels" : old_save_data.record_10_levels
		}
	elif num_levels == 10: 
		save_dict = {
			"record_3_levels"  : old_save_data.record_3_levels,
			"record_5_levels" : old_save_data.record_5_levels,
			"record_10_levels" : new_record
		}
	else:
		print("Initializing first time records...")
		save_dict = {
			"record_3_levels"  : -1,
			"record_5_levels" : -1,
			"record_10_levels" : -1
		}
		
	json_string = JSON.stringify(save_dict)
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
		
		return {"record_3_levels"  : -1,
				"record_5_levels" : -1,
				"record_10_levels" : -1}
	
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
		
		
	return saved_data


#func delete_save_file():
	#var file_path = "user://savegame.save"
	#if FileAccess.file_exists(file_path):
		#var error = FileAccess.remove(file_path)
		#if error == OK:
			#print("File deleted successfullly!")
