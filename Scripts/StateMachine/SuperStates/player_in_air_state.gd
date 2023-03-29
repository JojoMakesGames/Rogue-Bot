extends PlayerRobotState
class_name PlayerInAirState

var direction: float
var is_jumping: bool
var cut_jump: bool
var time_since_jump: int
var jump_input_stop: bool:
	get: return state_machine.jumping.jump_input_stop
var gravity
	
func physics_update(delta):
	super.physics_update(delta)
	player.velocity.y -= player.gravity * delta
	print_debug(player.velocity.y)
	direction = Input.get_axis("left", "right")
	#player.velocity.x = move_toward(player.velocity.x, direction * player.SPEED, player.SPEED)
	
	player.move_and_slide()

func handle_input(delta):
	super.handle_input(delta)
	if player.is_on_floor():
		state_machine.change_state(state_machine.idle)
	elif Input.is_action_just_pressed("jump") and state_machine.jumping.can_jump():
		state_machine.change_state(state_machine.jumping)


func check_jump_multiplier():
	if is_jumping:
		time_since_jump = Time.get_ticks_msec() - start_time
		if !cut_jump:
			cut_jump = !Input.is_action_pressed("jump") and time_since_jump < 200
		if cut_jump and 200 < time_since_jump:
			player.velocity.y = 0
			is_jumping = false
			cut_jump = false
		elif player.velocity.y >= 0:
			is_jumping = false;
			cut_jump = false;

