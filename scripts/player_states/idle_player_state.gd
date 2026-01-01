class_name IdlePlayerState
extends BasePlayerState

# Called when we first enter this state
func enter(player: Player) -> void:
	# Play idle animation when not moving
	player.anim_tree.set("parameters/movement/transition_request", "idle")
	
func pre_update(player: Player) -> void:
	var direction := player.get_move_input()
	
	# Update animations based on current velocity and movement state
	# Calculate current movement speed (magnitude of velocity vector)
	#var current_speed := player.get_current_speed()
	
	if not player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)
		# Determine which animation state to play based on movement conditions
	#elif current_speed > player.run_speed:
		#player.change_state_to(PlayerStates.RUN)
	elif direction.length() > 0.0:
		player.change_state_to(PlayerStates.WALK)
	elif Input.is_action_just_pressed("ui_accept"):
		player.change_state_to(PlayerStates.JUMP)
