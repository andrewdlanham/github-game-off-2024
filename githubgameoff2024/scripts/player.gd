extends CharacterBody2D


const SPEED = 140.0
const JUMP_VELOCITY = -300.0

@onready var player_sprite: Sprite2D = $Sprite2D

var is_enabled: bool

func _physics_process(delta: float) -> void:
	
	if not is_enabled: return
	
	# Handle gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Handle sprite flipping
	if direction == -1: player_sprite.flip_h = true
	elif direction == 1: player_sprite.flip_h = false
	
	#
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# TODO: Check what this function does
	move_and_slide()
