extends Node

@onready var play_5_words: Button = $Play5Words

@onready var menu_scene: Node = %MenuScene
@onready var save_manager = get_node("/root/Game/SaveManager")

@onready var best_5_word_time: Label = $Best5WordTime


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var save_data = save_manager.load_game()
	best_5_word_time.text = "Best Time: " + str(save_data.record_5_levels)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_reset_records_button_pressed() -> void:
	print("Resetting records...")
	save_manager.save_game(-1, -1, true)


func _on_play_5_words_pressed() -> void:
	save_manager.selected_num_levels = 5
	print("Loading game...")
	var gameplay_scene = load("res://scenes/gameplay_scene.tscn")
	get_tree().root.add_child(gameplay_scene.instantiate())
	
	menu_scene.queue_free()
