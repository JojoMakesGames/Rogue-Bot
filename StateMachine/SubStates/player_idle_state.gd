extends PlayerGroundedState
class_name PlayerIdleState

var x_input: float

func physics_update(delta):
	super.physics_update(delta)
	player.velocity.y = .0001
	
	player.move_and_slide()

func handle_input(delta):
	super.handle_input(delta)
	x_input = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")
	if player.is_on_floor() and x_input:
		state_machine.change_state(state_machine.moving)
	elif !player.is_on_floor():
		state_machine.change_state(state_machine.in_air)
	
