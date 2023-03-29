extends PlayerAbilityState
class_name PlayerJumpingState

@export var max_jumps: int = 2
var number_of_jumps_left: int = max_jumps

func enter():
	super.enter()
	player.velocity.y = player.JUMP_VELOCITY
	number_of_jumps_left -= 1
	is_ability_done = true;
	state_machine.in_air.is_jumping = true
	player.move_and_slide()
	
func exit():
	super.exit()
	
func can_jump():
	return number_of_jumps_left > 0

func reset_jumps():
	number_of_jumps_left = max_jumps
