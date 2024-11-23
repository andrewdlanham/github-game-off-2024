extends CharacterBody2D


const SPEED = 140.0
const JUMP_VELOCITY = -300.0

@onready var player: CharacterBody2D = $"."
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player_sprite: Sprite2D = $Sprite2D
@onready var sound_jump: AudioStreamPlayer2D = $SoundJump

const jump_sound = preload("res://retro-jump-3-236683.mp3")

var is_enabled: bool

func _ready() -> void:
	is_enabled = true

func _physics_process(delta: float) -> void:
	
	if not is_enabled: return
	
	# Handle gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sound_jump.play()

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

func disable_movement():
	#print("Disabling movement...")
	set_physics_process(false)
	
func enable_movement():
	#print("Enabling movement...")
	set_physics_process(true)
	
func disable_collision():
	collision_shape.disabled = true

func enable_collision():
	collision_shape.disabled = false
	
func move_to_spawn():
	var player_spawn_point = get_tree().get_nodes_in_group("PlayerSpawnPoint")
	player.position = player_spawn_point[0].position
