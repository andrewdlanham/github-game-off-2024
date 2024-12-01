extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var letter_label: Label = $LetterLabel
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

@onready var secret_word_label

var letterPosition # Letter's position in secret word
var hiddenLetter = ''
var letterCollected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("Letter ready.")
	letter_label.text = '?'
	

func _on_body_entered(_body: Node2D) -> void:
	
	if !letterCollected && _body.is_in_group("Player"):
		print(self.name + "collected!")
		letterCollected = true
		collect_sound.play()
		secret_word_label.text[letterPosition] = hiddenLetter
		self.visible = false
		get_node("/root/GameplayScene/LevelManager").check_for_level_end(null)
	
