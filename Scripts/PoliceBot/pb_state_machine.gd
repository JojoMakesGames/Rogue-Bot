extends PlayerStateMachine

class_name PoliceStateMachine

@export var moving: PoliceMovingState

@export var player: PoliceBot
@export var animation_player: AnimationPlayer

func _ready():
	state = get_child(0) as PlayerState
	state.state_machine = self
	state.player = player
	state.animation = animation_player
	state.enter()
	
func change_state(new_state: PlayerState):
	state.exit()
	state = new_state
	if !state.state_machine:
		state.state_machine = self
	if !state.player:
		state.player = self.player
	if !state.animation:
		state.animation = animation_player
	state.enter()
