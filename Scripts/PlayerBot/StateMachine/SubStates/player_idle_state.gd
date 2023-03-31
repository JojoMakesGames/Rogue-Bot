extends PlayerGroundedState
class_name PlayerIdleState

var x_input: float

func enter():
	super.enter()
	self.animation.play("Robot_Idle")

func handle_input(delta):
	super.handle_input(delta)
	if player.is_on_floor() and Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		state_machine.change_state(state_machine.moving)
	elif !player.is_on_floor():
		state_machine.change_state(state_machine.in_air)
	
