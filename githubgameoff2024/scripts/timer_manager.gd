extends Node

@onready var timer_label: Label = %TimerLabel

var is_timer_paused: bool
var elapsed_time: float = 0.00

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Update elapsed_time if timer is unpaused
	if !is_timer_paused:
		elapsed_time += delta
		timer_label.text = get_formatted_elapsed_time()

func unpause_timer():
	is_timer_paused = false
	
func pause_timer():
	is_timer_paused = true
	
func get_formatted_elapsed_time():
	var minutes = int(elapsed_time / 60)
	var seconds = elapsed_time - (minutes * 60)
	var format_string
	if minutes > 0: format_string = str(minutes) + ":" + "%.*f"
	else: format_string = "%.*f"
	return (format_string % [1, seconds])
	
