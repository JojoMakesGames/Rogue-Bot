extends PlayerState
class_name PoliceShootingState

@export var laser: PackedScene
var is_ability_done: bool = false

func enter():
	is_ability_done = false
	player.shoot()
	is_ability_done = true

func handle_input(delta):
	super.handle_input(delta)
	if is_ability_done:
		state_machine.change_state(state_machine.idle)

