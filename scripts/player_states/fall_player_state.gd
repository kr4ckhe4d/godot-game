class_name FallPlayerState
extends BasePlayerState

# Called when we first enter this state
func enter(player: Player) -> void:
	# Play falling animation when in the air
	player.anim_tree.set("parameters/movement/transition_request", "fall")

func pre_update(player: Player) -> void:
	if player.is_on_floor():
		player.change_state_to(PlayerStates.IDLE)

# Called when we first exit this state
func exit(player: Player) -> void:
	pass
	
# Called for every physics frame that we're in this state
func update(player: Player, delta: float) -> void:
	var direction := player.get_move_input()
	player.update_velocity_using_direction(direction, player.base_speed * 0.25)
	# Add gravity when not on the ground
	player.velocity += player.get_gravity() * delta
	player.move_and_slide()
	player.turn_to(direction)
