extends Node

@onready var menu_scene: Node = get_node("/root/Game/MenuScene")
@onready var save_manager = get_node("/root/Game/SaveManager")

@onready var buttons: Control = $Buttons

@onready var record_3_words: Label = $Buttons/Play3Words/Panel/Record3Words
@onready var record_5_words: Label = $Buttons/Play5Words/Panel/Record5Words
@onready var record_10_words: Label = $Buttons/Play10Words/Panel/Record10Words
@onready var how_to_play_box: Control = $HowToPlayBox



@onready var sound_manager: Node = get_node("/root/Game/SoundManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	save_manager.is_on_menu = true
	
	var cursor_texture = preload("res://cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture)
	
	sound_manager.gameplay_music.stop()
	sound_manager.menu_music.play()
	
	var save_data = save_manager.load_game()

	# Handle first time setup for records
	await save_manager.save_game(0,0,false, save_data)
		
	if save_data:
		if (save_data.record_3_levels) != -1:
			record_3_words.text = "Record: " + get_formatted_time(float(save_data.record_3_levels))
		if (save_data.record_5_levels) != -1:
			record_5_words.text = "Record: " + get_formatted_time(float(save_data.record_5_levels))
		if (save_data.record_10_levels) != -1:
			record_10_words.text = "Record: " + get_formatted_time(float(save_data.record_10_levels))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_reset_records_button_pressed() -> void:
	print("Resetting records...")
	save_manager.save_game(-1, -1, true, save_manager.load_game())

func trigger_start_game():
	print("Loading game...")
	var gameplay_scene = load("res://scenes/gameplay_scene.tscn")
	get_tree().root.add_child(gameplay_scene.instantiate())
	await get_tree().create_timer(0.1).timeout
	menu_scene.free()

func _on_play_3_words_pressed() -> void:
	sound_manager.guess_correct_sound.play()
	await get_tree().create_timer(0.25).timeout
	print("3 words selected")
	save_manager.selected_num_levels = 3
	trigger_start_game()

func _on_play_5_words_pressed() -> void:
	sound_manager.guess_correct_sound.play()
	await get_tree().create_timer(0.25).timeout
	print("5 words selected")
	save_manager.selected_num_levels = 5
	trigger_start_game()

func _on_play_10_words_pressed() -> void:
	sound_manager.guess_correct_sound.play()
	await get_tree().create_timer(0.25).timeout
	print("10 words selected")
	save_manager.selected_num_levels = 10
	trigger_start_game()

func get_formatted_time(time):
	var minutes = int(time / 60)
	var seconds = time - (minutes * 60)
	var format_string
	if minutes > 0: 
		format_string = str(minutes) + ":" + "%.*f"
		if seconds < 10:
			format_string = str(minutes) + ":0" + "%.*f"
	else: format_string = "%.*f"
	return (format_string % [1, seconds])
	


func _on_how_to_play_pressed() -> void:
	sound_manager.timer_tick_sound.play()
	buttons.visible = false
	how_to_play_box.visible = true


func _on_cancel_how_to_play_pressed() -> void:
	sound_manager.timer_tick_sound.play()
	how_to_play_box.visible = false
	buttons.visible = true
