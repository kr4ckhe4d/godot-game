extends CharacterBody3D

# Player movement and control script
# Handles movement, jumping, gravity, and character rotation based on camera orientation

# Movement speed in units per second (configurable in editor)
@export var speed: float = 5.0
# Initial upward velocity applied when jumping
const JUMP_VELOCITY = 4.5
# Reference to the camera rig to determine movement direction relative to view
@onready var camera: Node3D = $CameraRig/Camera3D

# Main physics loop - runs every frame for movement and gravity
func _physics_process(delta: float) -> void:
	# Add gravity when not on the ground
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump when space/accept button is pressed and player is on ground
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get raw input vector from directional keys
	# (move_left, move_right, move_forward, move_backward are custom input actions)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# Convert input direction to world space based on camera orientation
	var direction := (camera.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Flatten the direction vector (ignore vertical component) and scale by input magnitude
	# This prevents movement in the up/down direction and maintains input strength
	direction = Vector3(direction.x, 0, direction.z).normalized() * input_dir.length()
	
	# Apply horizontal movement based on direction input
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# Apply velocity to the character and handle collisions
	move_and_slide()
	# Update character rotation to face movement direction
	turn_to(direction)

# Rotate the character to face the given direction
# Uses lerp_angle for smooth, gradual rotation instead of snapping
func turn_to(direction: Vector3) -> void:
	if direction:
		# Calculate the yaw angle from the direction vector
		var yaw := atan2(-direction.x, -direction.z)
		# Smoothly interpolate between current and target rotation (0.25 = 25% per frame)
		yaw = lerp_angle(rotation.y, yaw, 0.25)
		rotation.y = yaw
