extends PlayerGroundedState
class_name PlayerMovingState

var input_dir: Vector2:
	get:
		return Input.get_vector("left", "right", "up", "down")
		
var direction

	
func physics_update(delta):
	super.physics_update(delta)
	if direction:
		player.velocity.x = direction.x * player.SPEED
		player.velocity.z = direction.z * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	player.move_and_slide()
	

func handle_input(delta):
	super.handle_input(delta)
	var forward = player.global_transform.basis.z
	var right = player.global_transform.basis.x
	direction = (forward * input_dir.y + right * input_dir.x).normalized()
	if player.velocity == Vector3.ZERO and direction == Vector3.ZERO:
		state_machine.change_state(state_machine.idle)
	if !player.is_on_floor():
		state_machine.change_state(state_machine.in_air)

