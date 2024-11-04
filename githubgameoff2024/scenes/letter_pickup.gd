extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var letterPosition # Letter's position in secret word

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	print("Letter picked up!")
	
	# TODO: Add letter to hidden word
	
	queue_free()
