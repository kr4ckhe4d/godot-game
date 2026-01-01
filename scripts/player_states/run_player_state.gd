class_name RunPlayerState
extends BasePlayerState

# Called when we first enter this state
func enter(player: Player) -> void:
	# Play running animation and apply side-leaning based on input direction
	player.anim_tree.set("parameters/movement/transition_request", "run")

func pre_update(player: Player) -> void:
	var current_speed := player.get_current_speed()
	
	if not player.is_on_floor():
		player.change_state_to(PlayerStates.FALL)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			player.change_state_to(PlayerStates.JUMP)
		
		if(current_speed)==0:
			player.change_state_to(PlayerStates.IDLE)
		elif current_speed < player.run_speed:
			player.change_state_to(PlayerStates.WALK)
	
# Called for every physics frame that we're in this state
func update(player: Player, delta: float) -> void:
	var direction := player.get_move_input()
	player.update_velocity_using_direction(direction)
	
	# Apply velocity to the character and handle collisions
	player.move_and_slide()
	# Update character rotation to face movement direction
	player.turn_to(direction)
	
	# Calculate how much the character leans left/right based on input
	var lean := direction.dot(player.global_basis.x)
	# Smoothly interpolate lean value to avoid sharp transitions
	player.last_lean = lerpf(player.last_lean, lean, 0.3)
	player.anim_tree.set("parameters/run_lean/add_amount", player.last_lean)
