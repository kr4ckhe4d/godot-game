# Dont forget to tick top level on camera rig->transform

extends SpringArm3D

# Reference to the Camera3D node attached to this SpringArm3D
@onready var camera: Camera3D = get_node("Camera3D")

# Controls how fast the camera rotates from keyboard input (degrees per second)
var turn_rate := 60

# Multiplier for mouse movement sensitivity
var mouse_sensitivity := 0.5

# Accumulates relative mouse movement input each frame
var mouse_input: Vector2 = Vector2()

# Reference to the player node that this camera rig is a child of
@onready var player: Node3D = get_parent()

# Stores the initial Y position of the camera rig to maintain consistent height above player
@onready var camera_rig_height: float = position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set spring arm length to match camera's Z position for proper collision detection
	spring_length = camera.position.z
	# Capture the mouse cursor so it doesn't leave the game window
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(_delta: float) -> void:
	# Keep camera rig positioned above player, accounting for the initial height offset
	position = player.position + Vector3(0, camera_rig_height, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get keyboard input for camera rotation (using view_left/right/up/down actions)
	var look_input := Input.get_vector("view_left", "view_right", "view_up", "view_down")
	
	# Scale keyboard input by turn_rate and delta time for frame-rate independent movement
	look_input = turn_rate * look_input * delta
	
	# Combine keyboard input with accumulated mouse input
	look_input += mouse_input
	
	# Apply rotation: X for pitch (up/down), Y for yaw (left/right)
	rotation_degrees.x += look_input.y
	rotation_degrees.y += look_input.x
	
	# Clamp pitch to prevent camera from rotating too far up or down
	rotation_degrees.x = clampf(rotation_degrees.x, -70, 70)
	
	# Reset mouse input each frame to avoid accumulation
	mouse_input = Vector2()

func _input(event: InputEvent) -> void:
	# Handle mouse movement input
	if event is InputEventMouseMotion:
		# Negate the relative mouse movement and apply sensitivity multiplier
		mouse_input = - event.relative * mouse_sensitivity
	
	# Handle ESC key to release the mouse cursor
	elif event is InputEventKey and event.keycode == KEY_ESCAPE and event.is_pressed():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Handle left mouse click to recapture the mouse when visible
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
