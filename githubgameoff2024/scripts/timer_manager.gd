extends Node

@onready var timer_label: Label = %TimerLabel

var is_timer_paused: bool = true
var elapsed_time: float = 0.00

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Update elapsed_time if timer is unpaused
	if !is_timer_paused:
		elapsed_time += delta
		timer_label.text = get_formatted_time(elapsed_time)

func unpause_timer():
	is_timer_paused = false
	
func pause_timer():
	is_timer_paused = true
	
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
	
