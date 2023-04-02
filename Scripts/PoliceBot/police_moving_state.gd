extends PlayerState
class_name PoliceMovingState

func enter():
	self.animation.play("Walk")

func physics_update(delta):
	super.physics_update(delta)
	if player.input_direction:
		player.velocity.x = player.input_direction.x * player.SPEED
		player.velocity.z = player.input_direction.z * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	player.move_and_slide()

func handle_input(delta):
	super.handle_input(delta)
	if player.velocity == Vector3.ZERO and player.input_direction == Vector3.ZERO:
		state_machine.change_state(state_machine.idle)
	elif Input.is_action_just_pressed("shoot"):
		state_machine.change_state(state_machine.shooting)

