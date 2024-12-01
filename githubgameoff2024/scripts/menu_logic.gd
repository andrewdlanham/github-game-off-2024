extends Node

@onready var menu_scene: Node = get_node("/root/Game/MenuScene")
@onready var save_manager = get_node("/root/Game/SaveManager")

@onready var record_3_words: Label = $Play3Words/Panel/Record3Words
@onready var record_5_words: Label = $Play5Words/Panel/Record5Words
@onready var record_10_words: Label = $Play10Words/Panel/Record10Words
@onready var sound_manager: Node = get_node("/root/Game/SoundManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
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
			record_3_words.text = "Record: " + str(save_data.record_3_levels)
		if (save_data.record_5_levels) != -1:
			record_5_words.text = "Record: " + str(save_data.record_5_levels)
		if (save_data.record_10_levels) != -1:
			record_10_words.text = "Record: " + str(save_data.record_10_levels)

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
	print("3 words selected")
	save_manager.selected_num_levels = 3
	trigger_start_game()

func _on_play_5_words_pressed() -> void:
	print("5 words selected")
	save_manager.selected_num_levels = 5
	trigger_start_game()

func _on_play_10_words_pressed() -> void:
	print("10 words selected")
	save_manager.selected_num_levels = 10
	trigger_start_game()
