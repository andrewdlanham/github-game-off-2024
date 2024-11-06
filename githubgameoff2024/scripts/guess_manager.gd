extends Node

@onready var game_manager: Node2D = %GameManager
@onready var player: CharacterBody2D = %Player
@onready var guess_input_box: LineEdit = %GuessInputBox

var guessing_mode_enabled: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	guessing_mode_enabled = false
	
	guess_input_box.visible = false 	# Hide guess input box


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_guess") and not guessing_mode_enabled:
		enter_guessing_mode()
	elif Input.is_action_just_pressed("toggle_guess"):
		game_manager.check_for_correct_guess(guess_input_box.text)
		exit_guessing_mode()
		
func enter_guessing_mode():
	print("Entering guessing mode...")
	player.is_enabled = false
	guessing_mode_enabled = true
	guess_input_box.visible = true
	guess_input_box.grab_focus()

func exit_guessing_mode():
	print("Exiting guessing mode...")
	player.is_enabled = true
	guessing_mode_enabled = false
	guess_input_box.visible = false
	guess_input_box.text = ""
	guess_input_box.release_focus()

	
