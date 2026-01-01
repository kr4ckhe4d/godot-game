class_name WalkPlayerState
extends BasePlayerState

# Called when we first enter this state
func enter(player: Player) -> void:
	# Play walking animation with speed-based animation playback rate
	player.anim_tree.set("parameters/movement/transition_request", "walk")

func pre_update(player: Player) -> void:
	var current_speed := player.get_current_speed()
	
	if not player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			player.change_state_to(PlayerStates.JUMP)
		
		if(current_speed)==0:
			player.change_state_to(PlayerStates.IDLE)
		elif current_speed > player.run_speed:
			player.change_state_to(PlayerStates.RUN) 
	
# Called for every physics frame that we're in this state
func update(player: Player, delta: float) -> void:
	var direction := player.get_move_input()
	player.update_velocity_using_direction(direction)
	
	# Apply velocity to the character and handle collisions
	player.move_and_slide()
	# Update character rotation to face movement direction
	player.turn_to(direction)
	
	# Scale walk animation speed based on actual movement speed (0.5x to 1.75x)
	var walk_speed := lerpf(0.5, 1.75, player.get_current_speed() / player.run_speed)
	player.anim_tree.set("parameters/walk_speed/scale", walk_speed)
