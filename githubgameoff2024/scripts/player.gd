extends CharacterBody2D


const SPEED = 120.0
const JUMP_VELOCITY = -250.0
const WALL_JUMP_FORCE = Vector2(-400, -250)

@onready var player: CharacterBody2D = $"."
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_jump: AudioStreamPlayer2D = $SoundJump

var is_enabled: bool
var is_jumping: bool

func _ready() -> void:
	is_enabled = true
	is_jumping = true

func _physics_process(delta: float) -> void:
	
	if not is_enabled: return
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	
	# Handle sprite flipping
	if direction == -1: animated_sprite_2d.flip_h = true
	elif direction == 1: animated_sprite_2d.flip_h = false
	
	#
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		if is_on_wall() && direction:
			velocity.y = velocity.y * 0.7
		is_jumping = true
	else: is_jumping = false
	
	# Handle wall jumping
	if Input.is_action_just_pressed("jump") && is_on_wall():
		if velocity.x < 0:  # Touching the left wall
			velocity.x = -WALL_JUMP_FORCE.x
		else:  # Touching the right wall
			velocity.x = WALL_JUMP_FORCE.x
		velocity.y = WALL_JUMP_FORCE.y  # Apply upward force
		sound_jump.play()
		
	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sound_jump.play()
	
	# Handle animation
	if is_on_wall() && !is_on_floor():
		animated_sprite_2d.animation = "wall_slide"
	elif is_jumping:
		animated_sprite_2d.animation = "jump"
	elif direction:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"
	
	animated_sprite_2d.play()

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
