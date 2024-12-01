extends Control

var tween_intensity = 1.2
var tween_duration = 0.3

@onready var play_3_words: Button = $Play3Words
@onready var play_5_words: Button = $Play5Words
@onready var play_10_words: Button = $Play10Words
@onready var how_to_play: Button = $HowToPlay
@onready var reset_records_button: Button = $ResetRecordsButton


func _process(_delta: float) -> void:
	handle_button_hover(play_3_words)
	handle_button_hover(play_5_words)
	handle_button_hover(play_10_words)
	handle_button_hover(how_to_play)
	handle_button_hover(reset_records_button)
	
func handle_button_hover(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)
		
func start_tween(object: Object, property: String, final_val: Variant, duration:float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)
