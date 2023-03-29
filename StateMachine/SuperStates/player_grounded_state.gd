extends PlayerState
class_name PlayerGroundedState

func enter():
	super.enter()
	state_machine.jumping.reset_jumps()
	print_debug("Enter Grounded State")

func handle_input(delta):
	super.handle_input(delta)
	print_debug("Handling Input")
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(state_machine.jumping)
	elif Input.is_action_pressed("shoot") and state_machine.shooting.check_can_shoot(Time.get_ticks_msec()):
		state_machine.change_state(state_machine.shooting)
	elif Input.is_action_just_released("glaive_dash") and state_machine.glaive_dashing.can_dash():
		state_machine.change_state(state_machine.glaive_dashing)
	elif !player.is_on_floor():
		print_debug("Not on floor")
		state_machine.change_state(state_machine.in_air)
