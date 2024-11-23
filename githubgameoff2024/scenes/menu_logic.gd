extends Node

@onready var start_game_button: Button = $StartGameButton
@onready var menu_scene: Node = %MenuScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	print("Loading game...")
	var gameplay_scene = load("res://scenes/gameplay_scene.tscn")
	get_tree().root.add_child(gameplay_scene.instantiate())
	menu_scene.queue_free()
