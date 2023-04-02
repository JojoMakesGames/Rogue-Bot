extends PlayerState
class_name PoliceIdleState

func enter():
	self.animation.play("Idle")

func handle_input(delta):
	super.handle_input(delta)
	if player.input_direction != Vector3.ZERO:
		state_machine.change_state(state_machine.moving)
	elif Input.is_action_just_pressed("shoot"):
		state_machine.change_state(state_machine.shooting)

