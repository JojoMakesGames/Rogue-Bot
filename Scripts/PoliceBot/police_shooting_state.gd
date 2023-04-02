extends PlayerState
class_name PoliceShootingState

@export var laser: PackedScene
var is_ability_done: bool = false

func enter():
	is_ability_done = false
	player.shoot()
	if !player.finished_shooting.is_connected(_on_policebot_finished_shooting):
		player.finished_shooting.connect(_on_policebot_finished_shooting)

func handle_input(delta):
	super.handle_input(delta)
	if is_ability_done:
		state_machine.change_state(state_machine.idle)
		
func _on_policebot_finished_shooting():
	is_ability_done = true

