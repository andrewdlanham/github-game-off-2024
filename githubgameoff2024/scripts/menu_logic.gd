extends Node

@onready var play_5_words: Button = $Play5Words
@onready var play_15_words: Button = $Play15Words


@onready var menu_scene: Node = %MenuScene
@onready var save_manager = get_node("/root/Game/SaveManager")

@onready var record_5_words: Label = $Play5Words/Panel/Record5Words
@onready var record_15_words: Label = $Play15Words/Panel/Record15Words
@onready var record_25_words: Label = $Play25Words/Panel/Record25Words


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_data = save_manager.load_game()
	if (save_data.record_5_levels) != -1:
		record_5_words.text = "Record: " + str(save_data.record_5_levels)
	if (save_data.record_15_levels) != -1:
		record_5_words.text = "Record: " + str(save_data.record_15_levels)
	if (save_data.record_25_levels) != -1:
		record_5_words.text = "Record: " + str(save_data.record_25_levels)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_reset_records_button_pressed() -> void:
	print("Resetting records...")
	save_manager.save_game(-1, -1, true)

func _on_play_5_words_pressed() -> void:
	print("5 words selected")
	save_manager.selected_num_levels = 5
	trigger_start_game()
	
func _on_play_15_words_pressed() -> void:
	print("15 words selected")
	save_manager.selected_num_levels = 15
	trigger_start_game()

func _on_play_25_words_pressed() -> void:
	print("25 words selected")
	save_manager.selected_num_levels = 25
	trigger_start_game()

func trigger_start_game():
	print("Loading game...")
	var gameplay_scene = load("res://scenes/gameplay_scene.tscn")
	get_tree().root.add_child(gameplay_scene.instantiate())
	menu_scene.queue_free()
