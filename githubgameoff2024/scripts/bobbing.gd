extends Node


var bobbing_speed = 4
var bobbing_amplitude = 3
var default_position

func _process(_delta):
	# Bob up and down
	self.position.y = default_position.y + sin(Time.get_ticks_msec() / 1000.0 * bobbing_speed) * bobbing_amplitude

func _ready() -> void:
	default_position = self.position
