class_name Player
extends CharacterBody3D

# Tracks the previous lean value for smooth interpolation during running
var last_lean := 0.0
# Reference to the AnimationTree for controlling animation state machine
@onready var anim_tree: AnimationTree = $AnimationTree
# Reference to the AnimationPlayer that actually plays the animations
@onready var anim_player: AnimationPlayer = $mesh/AnimationPlayer
# Movement speed in units per second (configurable in editor)
@export var base_speed: float = 5.0
# Initial upward velocity applied when jumping
const JUMP_VELOCITY = 4.5
# Reference to the camera rig to determine movement direction relative to view
@onready var camera: Node3D = $CameraRig/Camera3D
# Speed threshold above which the character runs instead of walks
var run_speed := 4.0
# Default speed used to blend animations
#const BLEND_SPEED := 0.2

## The current state that our player is in
var state: BasePlayerState = PlayerStates.IDLE

func _ready() -> void:
	state.enter(self)

## Changes the current player state and runs the current functions
func change_state_to(next_state: BasePlayerState)->void:
	state.exit(self)
	state = next_state
	state.enter(self)

# Main physics loop - runs every frame for movement and gravity
func _physics_process(delta: float) -> void:
	state.pre_update(self)
	state.update(self, delta)

# Rotate the character to face the given direction
# Uses lerp_angle for smooth, gradual rotation instead of snapping
func turn_to(direction: Vector3) -> void:
	if direction:
		# Calculate the yaw angle from the direction vector
		var yaw := atan2(-direction.x, -direction.z)
		# Smoothly interpolate between current and target rotation (0.25 = 25% per frame)
		yaw = lerp_angle(rotation.y, yaw, 0.25)
		rotation.y = yaw

## Reads the directional movement input of the player, adjusts it
## on the camera and returns it.
func get_move_input() -> Vector3:
	# Get raw input vector from directional keys
	# (move_left, move_right, move_forward, move_backward are custom input actions)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Convert input direction to world space based on camera orientation
	var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Flatten the direction vector (ignore vertical component) and scale by input magnitude
	# This prevents movement in the up/down direction and maintains input strength
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	return direction

## Returns players current speed
func get_current_speed()-> float:
	return velocity.length()
	
## Applies velocity based on directional movement input
func update_velocity_using_direction(direction: Vector3, speed: float = base_speed) -> void:
	# Apply horizontal movement based on direction input
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
