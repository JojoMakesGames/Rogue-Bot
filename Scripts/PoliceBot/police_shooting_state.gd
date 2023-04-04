extends PlayerState
class_name PoliceShootingState

@export var laser: PackedScene
var is_ability_done: bool = false

func enter():
	is_ability_done = false
	self.animation.play("Shoot1")
	player.shoot(_finished_shooting)

func handle_input(delta):
	super.handle_input(delta)
	if is_ability_done:
		state_machine.change_state(state_machine.idle)
		
func _finished_shooting():
	is_ability_done = true

