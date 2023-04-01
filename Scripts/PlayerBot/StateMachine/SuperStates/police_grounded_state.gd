extends PlayerState
class_name PlayerGroundedState

func enter():
	super.enter()
	state_machine.jumping.reset_jumps()

func handle_input(delta):
	super.handle_input(delta)
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(state_machine.jumping)
	elif !player.is_on_floor():
		state_machine.change_state(state_machine.in_air)
