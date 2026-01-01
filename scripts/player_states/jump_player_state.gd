class_name JumpPlayerState
extends BasePlayerState

# Called when we first enter this state
func enter(player: Player) -> void:
	player.velocity.y = player.JUMP_VELOCITY
		# Play falling animation when in the air
	player.anim_tree.set("parameters/movement/transition_request", "fall")
	
func pre_update(player: Player) -> void:
	if player.velocity.y <= 0:
		player.change_state_to(PlayerStates.FALL)

func update(player: Player, delta: float) -> void:
	player.velocity += player.get_gravity() * delta
	var direction := player.get_move_input()
	player.update_velocity_using_direction(direction)
	player.move_and_slide()
	player.turn_to(direction)
