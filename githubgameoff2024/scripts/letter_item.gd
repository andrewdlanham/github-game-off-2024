extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var letter_label: Label = $LetterLabel
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

@onready var secret_word_label

var letterPosition # Letter's position in secret word
var hiddenLetter = ''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("Letter ready.")
	letter_label.text = '?'

func _on_body_entered(_body: Node2D) -> void:
	#print("Letter picked up: " + hiddenLetter)
	
	secret_word_label.text[letterPosition] = hiddenLetter
	collect_sound.play()
	await get_tree().create_timer(0.2).timeout
	queue_free()
